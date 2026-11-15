// API_URL нь config.js-ээс ирнэ.
const TOKEN_KEY = "admin_token";

const PAGES = {
  dashboard: { title: "Хяналт",          render: renderDashboard },
  tours:     { title: "Аялал",           render: (el) => toursPage(el) },
  bookings:  { title: "Захиалга",        render: (el) => bookingsPage(el) },
  customers: { title: "Үйлчлүүлэгч",     render: (el) => customersPage(el) },
  guides:    { title: "Хөтөч",           render: (el) => guidesPage(el) },
  forecast:  { title: "Эрэлт таамаглах", render: (el) => renderForecast(el) },
  facebook:  { title: "Facebook",        render: () => renderSoon("📘", "Тун удахгүй") },
};

const $ = (id) => document.getElementById(id);
const pageBody = $("page-body");

// ---------- Токен ----------
function getToken() { return sessionStorage.getItem(TOKEN_KEY); }

function readToken(token) {
  try {
    const part = token.split(".")[1].replace(/-/g, "+").replace(/_/g, "/");
    return JSON.parse(atob(part));
  } catch {
    return null;
  }
}

// Токентой хүсэлт. 401 ирвэл гаргаад нэвтрэх хуудас руу буцаана.
// Алдаа гарвал backend-ийн мессежийг (detail) Error болгож шиднэ.
async function api(path, { method = "GET", body } = {}) {
  let res;
  try {
    res = await fetch(API_URL + path, {
      method,
      headers: {
        Authorization: "Bearer " + getToken(),
        ...(body ? { "Content-Type": "application/json" } : {}),
      },
      body: body ? JSON.stringify(body) : undefined,
    });
  } catch {
    throw new Error("Backend-тэй холбогдож чадсангүй.");
  }
  if (res.status === 401) {
    // Токен хүчингүй / хугацаа дууссан → нэвтрэх хуудас руу буцна
    logout("Нэвтрэлтийн хугацаа дууссан. Дахин нэвтэрнэ үү.");
    throw new Error("unauthorized");
  }
  if (!res.ok) {
    let msg = "Серверт алдаа гарлаа.";
    try {
      const data = await res.json();
      if (typeof data.detail === "string") msg = data.detail;
      else if (Array.isArray(data.detail)) msg = "Оруулсан утга буруу байна. Талбаруудаа шалгана уу.";
    } catch {}
    const err = new Error(msg);
    err.status = res.status;
    throw err;
  }
  return res.json();
}

// ---------- Нэвтрэх / гарах ----------
const form = $("login-form");
const errorEl = $("error");
const loginBtn = $("login-btn");

form.addEventListener("submit", async (e) => {
  e.preventDefault();
  errorEl.textContent = "";

  const email = $("email").value.trim();
  const password = $("password").value;
  if (!email || !password) {
    errorEl.textContent = "Имэйл болон нууц үгээ оруулна уу.";
    return;
  }

  loginBtn.disabled = true;
  loginBtn.textContent = "Түр хүлээнэ үү...";
  try {
    const res = await fetch(API_URL + "/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password }),
    });
    if (res.status === 401) {
      errorEl.textContent = "Имэйл эсвэл нууц үг буруу байна.";
      return;
    }
    if (!res.ok) {
      errorEl.textContent = "Серверт алдаа гарлаа. Дахин оролдоно уу.";
      return;
    }
    const data = await res.json();
    sessionStorage.setItem(TOKEN_KEY, data.access_token);
    form.reset();
    showApp();
  } catch {
    errorEl.textContent = "Backend-тэй холбогдож чадсангүй.";
  } finally {
    loginBtn.disabled = false;
    loginBtn.textContent = "Нэвтрэх";
  }
});

function logout(message = "") {
  sessionStorage.removeItem(TOKEN_KEY);
  errorEl.textContent = typeof message === "string" ? message : "";
  $("app-view").classList.add("hidden");
  $("login-view").classList.remove("hidden");
}
$("logout-btn").addEventListener("click", logout);

function showApp() {
  const info = readToken(getToken());
  $("admin-email").textContent = info ? info.email : "";
  $("login-view").classList.add("hidden");
  $("app-view").classList.remove("hidden");
  navigate();
}

// ---------- Цэс ----------
function navigate() {
  const key = location.hash.slice(1);
  const page = PAGES[key] ? key : "dashboard";
  document.querySelectorAll("#menu a").forEach((a) => {
    a.classList.toggle("active", a.dataset.page === page);
  });
  $("page-title").textContent = PAGES[page].title;
  PAGES[page].render(pageBody);
}
window.addEventListener("hashchange", () => {
  if (getToken()) navigate();
});

// ---------- Хуудсууд ----------
const fmtNum = (n) => Number(n).toLocaleString("mn-MN");
const fmtMoney = (n) => "₮" + Math.round(Number(n)).toLocaleString("mn-MN");

function escapeHtml(s) {
  return String(s ?? "").replace(/[&<>"']/g, (c) =>
    ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c])
  );
}

function renderSoon(icon, text) {
  pageBody.innerHTML = `
    <div class="soon">
      <div class="soon-icon">${icon}</div>
      <h2>${text}</h2>
      <p>Энэ хэсэг хөгжүүлэгдэж байна.</p>
    </div>`;
}

async function renderDashboard() {
  pageBody.innerHTML = `<p class="empty">Ачаалж байна...</p>`;
  let s, top5 = [];
  try {
    [s, top5] = await Promise.all([
      api("/admin/stats"),
      api("/demand/tours?limit=5").catch((e) => { if (e.message === "unauthorized") throw e; return []; }),
    ]);
  } catch (err) {
    if (err.message !== "unauthorized") {
      pageBody.innerHTML = `<p class="error">Мэдээлэл ачаалж чадсангүй.</p>`;
    }
    return;
  }

  const rows = s.pending_bookings.map((b) => `
    <tr>
      <td>#${b.booking_id}</td>
      <td>${escapeHtml(b.customer_name)}</td>
      <td>${escapeHtml(b.tour_name)}</td>
      <td>${b.people ?? "-"}</td>
      <td>${b.booked_at ?? "-"}</td>
      <td><span class="badge">Хүлээгдэж буй</span></td>
    </tr>`).join("");

  pageBody.innerHTML = `
    <div class="stats">
      <div class="stat"><div class="stat-label">🗺️ Аялал</div><div class="stat-value">${fmtNum(s.tours)}</div></div>
      <div class="stat"><div class="stat-label">📅 Захиалга</div><div class="stat-value">${fmtNum(s.bookings)}</div></div>
      <div class="stat warn"><div class="stat-label">⏳ Хүлээгдэж буй</div><div class="stat-value">${fmtNum(s.pending)}</div></div>
      <div class="stat money"><div class="stat-label">💰 Нийт орлого</div><div class="stat-value">${fmtMoney(s.revenue)}</div></div>
    </div>

    <div class="panel">
      <h2>Батлагдаагүй сүүлийн 5 захиалга</h2>
      ${rows ? `
      <table>
        <thead><tr><th>№</th><th>Үйлчлүүлэгч</th><th>Аялал</th><th>Хүн</th><th>Огноо</th><th>Төлөв</th></tr></thead>
        <tbody>${rows}</tbody>
      </table>` : `<p class="empty">Хүлээгдэж буй захиалга алга 🎉</p>`}
    </div>

    <div class="panel mt">
      <h2>🔥 Эрэлттэй 5 аялал</h2>
      ${top5.length ? demandTable(top5) : `<p class="empty">Таамаглалын мэдээлэл алга.</p>`}
    </div>`;
}

// ---------- Эрэлт таамаглах ----------
function demandTable(rows) {
  const body = rows.map((r, i) => `
    <tr>
      <td>${i + 1}</td>
      <td>${escapeHtml(r.name)}</td>
      <td class="num">${fmtMoney(r.price_per_day)}</td>
      <td class="num">${r.guide_experience} жил</td>
      <td class="num">${r.days}</td>
      <td class="num"><b>${r.actual_bookings}</b></td>
      <td class="num">${r.predicted_bookings.toFixed(1)}</td>
    </tr>`).join("");
  return `
    <table>
      <thead><tr>
        <th>#</th><th>Аялал</th><th class="num">Өдрийн үнэ</th><th class="num">Хөтчийн туршлага</th>
        <th class="num">Хоног</th><th class="num">Бодит захиалга</th><th class="num">Таамаглал</th>
      </tr></thead>
      <tbody>${body}</tbody>
    </table>`;
}

async function renderForecast(el) {
  el.innerHTML = `
    <div class="panel pad">
      <h2 class="flat">Шинэ аяллын эрэлтийг таамаглах</h2>
      <form id="predict-form" class="predict-form" novalidate>
        <label>Өдрийн үнэ (₮)<input name="price_per_day" type="number" min="1" value="180000" required></label>
        <label>Хөтчийн туршлага (жил)<input name="guide_experience" type="number" min="0" value="8" required></label>
        <label>Хоног<input name="days" type="number" min="1" value="5" required></label>
        <button type="submit">Таамаглах</button>
      </form>
      <p class="error" id="predict-error" role="alert"></p>
      <div id="predict-result" class="predict-result hidden"></div>
    </div>

    <div class="panel mt">
      <h2>Хамгийн их захиалгатай 10 аялал: бодит ба таамаглал</h2>
      <div id="demand-table"><p class="empty">Ачаалж байна...</p></div>
    </div>`;

  const form = el.querySelector("#predict-form");
  const errEl = el.querySelector("#predict-error");
  const result = el.querySelector("#predict-result");

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    errEl.textContent = "";
    const params = new URLSearchParams();
    for (const name of ["price_per_day", "guide_experience", "days"]) {
      const v = form.elements[name].value.trim();
      if (v === "") {
        errEl.textContent = "Бүх талбарыг бөглөнө үү.";
        return;
      }
      params.set(name, v);
    }
    const btn = form.querySelector("button");
    btn.disabled = true;
    try {
      const r = await api("/predict-demand?" + params);
      result.innerHTML = `
        <div class="stat-label">Таамагласан захиалга</div>
        <div class="big">${r.predicted_bookings.toFixed(1)}</div>
        <div class="stat-label">${fmtMoney(r.price_per_day)}/өдөр · ${r.guide_experience} жилийн туршлагатай хөтөч · ${r.days} хоног</div>`;
      result.classList.remove("hidden");
    } catch (err) {
      if (err.message !== "unauthorized") errEl.textContent = err.message;
    } finally {
      btn.disabled = false;
    }
  });

  try {
    const rows = await api("/demand/tours?limit=10");
    el.querySelector("#demand-table").innerHTML = rows.length ? demandTable(rows) : `<p class="empty">Мэдээлэл алга.</p>`;
  } catch (err) {
    if (err.message !== "unauthorized") {
      el.querySelector("#demand-table").innerHTML = `<p class="error pad">${escapeHtml(err.message)}</p>`;
    }
  }
}

// ---------- Аялал (ерөнхий CRUD-ийн тохиргоо) ----------
async function guideOptions() {
  const list = await api("/admin/guides");
  return list.map((g) => ({ value: g.guide_id, label: g.full_name }));
}

const toursPage = createCrudPage({
  endpoint: "/tours",
  idField: "tour_id",
  itemName: "аялал",
  itemNameAcc: "аяллыг",
  displayField: "name",
  searchKeys: ["name", "destination", "guide_name"],
  columns: [
    { key: "name",           label: "Нэр" },
    { key: "destination",    label: "Чиглэл" },
    { key: "days",           label: "Хоног", align: "right" },
    { key: "price",          label: "Үнэ",   align: "right", format: (v) => fmtMoney(v) },
    { key: "guide_name",     label: "Хөтөч" },
    { key: "bookings_count", label: "Захиалга", align: "right" },
  ],
  fields: [
    { key: "name",        label: "Нэр",          required: true },
    { key: "destination", label: "Чиглэл" },
    { key: "days",        label: "Хоног",        type: "number", min: 1, required: true },
    { key: "price",       label: "Үнэ (₮)",      type: "number", min: 1, required: true },
    { key: "start_date",  label: "Эхлэх огноо",  type: "date" },
    { key: "guide_id",    label: "Хөтөч",        type: "select", numeric: true, options: guideOptions },
  ],
});

// ---------- Захиалга ----------
const STATUS = {
  pending:   { label: "Хүлээгдэж буй", cls: "st-pending" },
  confirmed: { label: "Батлагдсан",    cls: "st-confirmed" },
  cancelled: { label: "Цуцлагдсан",    cls: "st-cancelled" },
};
const statusBadge = (v) =>
  `<span class="badge ${STATUS[v]?.cls || ""}">${STATUS[v]?.label || escapeHtml(v)}</span>`;
const statusOptions = Object.entries(STATUS).map(([value, s]) => ({ value, label: s.label }));

const setStatus = (row, status) =>
  api(`/bookings/${row.booking_id}/status`, { method: "PATCH", body: { status } });

async function tourOptions() {
  const list = await api("/admin/tour-options");
  return list.map((t) => ({ value: t.tour_id, label: t.name + (t.start_date ? ` (${t.start_date})` : "") }));
}
async function customerOptions() {
  const list = await api("/admin/customers");
  return list.map((c) => ({ value: c.customer_id, label: c.full_name + (c.country ? ` — ${c.country}` : "") }));
}

const bookingsPage = createCrudPage({
  endpoint: "/bookings",
  idField: "booking_id",
  itemName: "захиалга",
  itemNameAcc: "захиалгыг",
  displayText: (r) => `#${r.booking_id} ${r.customer_name} — ${r.tour_name}`,
  searchKeys: ["customer_name", "tour_name", "booking_id"],
  filters: [{ key: "status", label: "Төлөв", options: statusOptions }],
  columns: [
    { key: "booking_id",    label: "№", format: (v) => "#" + v },
    { key: "customer_name", label: "Үйлчлүүлэгч" },
    { key: "tour_name",     label: "Аялал" },
    { key: "people",        label: "Хүн", align: "right" },
    { key: "booked_at",     label: "Огноо" },
    { key: "paid_amount",   label: "Төлсөн", align: "right", format: (v) => (Number(v) > 0 ? fmtMoney(v) : "—") },
    { key: "status",        label: "Төлөв", format: statusBadge },
  ],
  fields: [
    { key: "tour_id",     label: "Аялал",        type: "select", numeric: true, required: true, options: tourOptions },
    { key: "customer_id", label: "Үйлчлүүлэгч",  type: "select", numeric: true, required: true, options: customerOptions },
    { key: "people",      label: "Хүний тоо",    type: "number", min: 1, required: true, default: 1 },
    { key: "status",      label: "Төлөв",        type: "select", required: true, default: "pending", options: statusOptions },
  ],
  // «Хүлээгдэж буй» захиалгад Батлах / Цуцлах товч
  rowActions: (row) => row.status !== "pending" ? [] : [
    { label: "Батлах", cls: "ok-btn",  done: "Захиалга батлагдлаа.",  run: (r) => setStatus(r, "confirmed") },
    { label: "Цуцлах", cls: "warn-btn", done: "Захиалга цуцлагдлаа.", run: (r) => setStatus(r, "cancelled") },
  ],
  // Төлбөртэй захиалгыг устгахгүй — оронд нь «Цуцлах»-ыг санал болгоно
  deleteBlocked: {
    label: "Цуцлах",
    show: (row) => row.status !== "cancelled",
    run: (row) => setStatus(row, "cancelled"),
    done: "Захиалга цуцлагдлаа.",
  },
});

// ---------- Үйлчлүүлэгч ----------
const customersPage = createCrudPage({
  endpoint: "/customers",
  idField: "customer_id",
  itemName: "үйлчлүүлэгч",
  itemNameAcc: "үйлчлүүлэгчийг",
  displayField: "full_name",
  searchKeys: ["full_name", "country", "email"],
  columns: [
    { key: "full_name",      label: "Нэр" },
    { key: "country",        label: "Улс" },
    { key: "email",          label: "И-мэйл" },
    { key: "bookings_count", label: "Захиалга", align: "right" },
  ],
  fields: [
    { key: "full_name", label: "Нэр",    required: true },
    { key: "country",   label: "Улс" },
    { key: "email",     label: "И-мэйл", type: "email" },
  ],
});

// ---------- Хөтөч ----------
const guidesPage = createCrudPage({
  endpoint: "/guides",
  idField: "guide_id",
  itemName: "хөтөч",
  itemNameAcc: "хөтчийг",
  displayField: "full_name",
  searchKeys: ["full_name", "language"],
  columns: [
    { key: "full_name",        label: "Нэр" },
    { key: "language",         label: "Хэл" },
    { key: "experience_years", label: "Туршлага", align: "right", format: (v) => (v == null ? "—" : v + " жил") },
    { key: "tours_count",      label: "Хариуцсан аялал", align: "right" },
  ],
  fields: [
    { key: "full_name",        label: "Нэр", required: true },
    { key: "language",         label: "Хэл" },
    { key: "experience_years", label: "Туршлага (жил)", type: "number", min: 0 },
  ],
});

// ---------- Эхлэл ----------
const saved = getToken();
const info = saved && readToken(saved);
if (info && info.exp * 1000 > Date.now()) {
  showApp();
} else {
  sessionStorage.removeItem(TOKEN_KEY);
}
