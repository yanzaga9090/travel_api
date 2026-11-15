// =====================================================================
//  Ерөнхий CRUD хуудас үүсгэгч
//
//  Ямар ч цэсэд (Аялал, Захиалга, Хөтөч ...) хүснэгт + хайлт +
//  «+ Нэмэх» / «Засах» / «Устгах» товчийг нэг тохиргоогоор үүсгэнэ.
//
//  createCrudPage({
//    endpoint: "/tours",            // backend зам
//    idField:  "tour_id",           // мөрийн ID талбар
//    itemName: "аялал",             // мессежүүдэд гарах нэр
//    itemNameAcc: "аяллыг",         // «... аяллыг устгах гэж байна»
//    displayField: "name",          // устгахдаа асуух нэр (эсвэл displayText: row => "...")
//    columns: [{ key, label, align?, format? }],
//    fields:  [{ key, label, type, required?, min?, default?, options? }],
//    searchKeys: ["name", ...],     // хайлт эдгээр талбараар хийгдэнэ
//
//    // --- Сонголттой ---
//    filters: [{ key, label, options: [{ value, label }] }],  // ?key=value шүүлтүүр
//    rowActions: (row) => [{ label, cls, run: async (row) => шинэМөр }],
//    deleteBlocked: { label, show: (row) => bool, run: async (row) => шинэМөр },
//  })
// =====================================================================

function createCrudPage(cfg) {
  const state = { rows: [], query: "", filters: {}, highlightId: null };
  const displayText = (row) =>
    cfg.displayText ? cfg.displayText(row) : String(row[cfg.displayField] ?? "");

  return async function render(container) {
    const filterSelects = (cfg.filters || []).map((f) => `
      <select class="filter" data-key="${f.key}" aria-label="${f.label}">
        <option value="">Бүх ${f.label.toLowerCase()}</option>
        ${f.options.map((o) => `<option value="${o.value}">${escapeHtml(o.label)}</option>`).join("")}
      </select>`).join("");

    container.innerHTML = `
      <div class="toolbar">
        <input type="search" class="search" placeholder="🔍 Хайх..." aria-label="Хайх">
        ${filterSelects}
        <button class="add-btn">+ Нэмэх</button>
      </div>
      <div class="panel"><p class="empty">Ачаалж байна...</p></div>`;

    const panel = container.querySelector(".panel");
    const search = container.querySelector(".search");

    search.value = state.query;
    search.addEventListener("input", () => {
      state.query = search.value;
      drawTable();
    });
    container.querySelectorAll(".filter").forEach((sel) => {
      sel.value = state.filters[sel.dataset.key] || "";
      sel.addEventListener("change", () => {
        state.filters[sel.dataset.key] = sel.value;
        load();
      });
    });
    container.querySelector(".add-btn").addEventListener("click", () => openForm(null));

    await load();

    // ---------- Өгөгдөл ачаалах ----------
    async function load() {
      const params = new URLSearchParams(
        Object.entries(state.filters).filter(([, v]) => v));
      const qs = params.toString() ? "?" + params : "";
      try {
        state.rows = await api(cfg.endpoint + qs);
        drawTable();
      } catch (err) {
        if (err.message !== "unauthorized") {
          panel.innerHTML = `<p class="error pad">Мэдээлэл ачаалж чадсангүй.</p>`;
        }
      }
    }

    function replaceRow(saved) {
      state.rows = state.rows.map((r) => (r[cfg.idField] === saved[cfg.idField] ? saved : r));
      state.highlightId = saved[cfg.idField];
      drawTable();
    }

    // ---------- Хүснэгт ----------
    function drawTable() {
      const q = state.query.trim().toLowerCase();
      const rows = q
        ? state.rows.filter((r) =>
            cfg.searchKeys.some((k) => String(r[k] ?? "").toLowerCase().includes(q)))
        : state.rows;

      if (!rows.length) {
        panel.innerHTML = `<p class="empty">${q ? "Хайлтад тохирох зүйл олдсонгүй." : "Одоогоор хоосон байна."}</p>`;
        return;
      }

      const head = cfg.columns.map((c) =>
        `<th class="${c.align === "right" ? "num" : ""}">${c.label}</th>`).join("") + `<th></th>`;
      const body = rows.map((r) => {
        const id = r[cfg.idField];
        const cells = cfg.columns.map((c) => {
          const v = c.format ? c.format(r[c.key], r) : escapeHtml(r[c.key] ?? "—");
          return `<td class="${c.align === "right" ? "num" : ""}">${v}</td>`;
        }).join("");
        const extra = (cfg.rowActions ? cfg.rowActions(r) : []).map((a, i) =>
          `<button class="small ${a.cls || ""} row-action" data-id="${id}" data-i="${i}">${a.label}</button>`).join("");
        return `
          <tr class="${id === state.highlightId ? "flash" : ""}">
            ${cells}
            <td class="actions">
              ${extra}
              <button class="small edit" data-id="${id}">Засах</button>
              <button class="small danger del" data-id="${id}">Устгах</button>
            </td>
          </tr>`;
      }).join("");

      panel.innerHTML = `
        <div class="count">${rows.length} ${cfg.itemName}</div>
        <table><thead><tr>${head}</tr></thead><tbody>${body}</tbody></table>`;

      const byId = (id) => state.rows.find((r) => String(r[cfg.idField]) === id);
      panel.querySelectorAll(".edit").forEach((b) =>
        b.addEventListener("click", () => openForm(byId(b.dataset.id))));
      panel.querySelectorAll(".del").forEach((b) =>
        b.addEventListener("click", () => confirmDelete(byId(b.dataset.id))));
      panel.querySelectorAll(".row-action").forEach((b) =>
        b.addEventListener("click", async () => {
          const row = byId(b.dataset.id);
          const action = cfg.rowActions(row)[Number(b.dataset.i)];
          b.disabled = true;
          try {
            replaceRow(await action.run(row));
            if (action.done) toast(action.done);
          } catch (err) {
            if (err.message !== "unauthorized") toast(err.message, true);
            b.disabled = false;
          }
        }));
    }

    // ---------- Нэмэх / Засах форм ----------
    async function openForm(row) {
      const isEdit = !!row;
      let inputs;
      try {
        inputs = await Promise.all(cfg.fields.map(async (f) => {
          const val = row ? row[f.key] ?? "" : f.default ?? "";
          const req = f.required ? "required" : "";
          const star = f.required ? ' <span class="req">*</span>' : "";
          let control;
          if (f.type === "select") {
            const opts = typeof f.options === "function" ? await f.options() : f.options;
            const blank = f.required ? "— Сонгоно уу —" : "— Сонгоогүй —";
            control = `<select name="${f.key}" ${req}>
                ${f.default === undefined || !f.required ? `<option value="">${blank}</option>` : ""}
                ${opts.map((o) => `<option value="${o.value}" ${String(o.value) === String(val) ? "selected" : ""}>${escapeHtml(o.label)}</option>`).join("")}
              </select>`;
          } else {
            const min = f.min !== undefined ? `min="${f.min}"` : "";
            control = `<input name="${f.key}" type="${f.type || "text"}" value="${escapeHtml(val)}" ${min} ${req}>`;
          }
          return `<label>${f.label}${star}${control}</label>`;
        }));
      } catch (err) {
        if (err.message !== "unauthorized") toast(err.message, true);
        return;
      }

      const dlg = openDialog(`
        <form method="dialog" class="crud-form" novalidate>
          <h2>${isEdit ? "Засах" : "Шинэ " + cfg.itemName + " нэмэх"}</h2>
          ${inputs.join("")}
          <p class="error form-error" role="alert"></p>
          <div class="dialog-actions">
            <button type="button" class="secondary cancel">Болих</button>
            <button type="submit">${isEdit ? "Хадгалах" : "Нэмэх"}</button>
          </div>
        </form>`);

      const form = dlg.querySelector("form");
      const errEl = dlg.querySelector(".form-error");

      form.addEventListener("submit", async (e) => {
        e.preventDefault();
        errEl.textContent = "";

        // Заавал бөглөх талбаруудыг шалгах
        const missing = cfg.fields.find((f) => f.required && !form.elements[f.key].value.trim());
        if (missing) {
          errEl.textContent = `«${missing.label}» талбарыг бөглөнө үү.`;
          form.elements[missing.key].focus();
          return;
        }

        const data = {};
        cfg.fields.forEach((f) => {
          const raw = form.elements[f.key].value.trim();
          data[f.key] = raw === "" ? null : f.type === "number" || f.numeric ? Number(raw) : raw;
        });

        const btn = form.querySelector('button[type="submit"]');
        btn.disabled = true;
        try {
          const saved = await api(
            isEdit ? `${cfg.endpoint}/${row[cfg.idField]}` : cfg.endpoint,
            { method: isEdit ? "PUT" : "POST", body: data },
          );
          dlg.close();
          if (isEdit) {
            replaceRow(saved);
            toast("Амжилттай хадгаллаа.");
          } else {
            state.rows.unshift(saved); // шинэ нь хамгийн дээр
            state.query = "";
            search.value = "";
            state.highlightId = saved[cfg.idField];
            drawTable();
            toast(`Шинэ ${cfg.itemName} нэмэгдлээ.`);
          }
        } catch (err) {
          if (err.message !== "unauthorized") errEl.textContent = err.message;
        } finally {
          btn.disabled = false;
        }
      });
    }

    // ---------- Устгах (заавал асууна) ----------
    function confirmDelete(row) {
      const name = escapeHtml(displayText(row));
      const dlg = openDialog(`
        <div class="confirm">
          <div class="confirm-icon">⚠️</div>
          <h2>Устгах уу?</h2>
          <p>«<b>${name}</b>» ${cfg.itemNameAcc || cfg.itemName} устгах гэж байна. Энэ үйлдлийг буцаах боломжгүй.</p>
          <p class="error form-error" role="alert"></p>
          <div class="dialog-actions">
            <button type="button" class="secondary cancel">Болих</button>
            <button type="button" class="alt hidden"></button>
            <button type="button" class="danger ok">Тийм, устгах</button>
          </div>
        </div>`);

      const okBtn = dlg.querySelector(".ok");
      const altBtn = dlg.querySelector(".alt");

      okBtn.addEventListener("click", async () => {
        okBtn.disabled = true;
        try {
          await api(`${cfg.endpoint}/${row[cfg.idField]}`, { method: "DELETE" });
          state.rows = state.rows.filter((r) => r[cfg.idField] !== row[cfg.idField]);
          dlg.close();
          drawTable();
          toast(`«${displayText(row)}» устгагдлаа.`);
        } catch (err) {
          if (err.message === "unauthorized") return;
          dlg.querySelector(".form-error").textContent = err.message;
          okBtn.classList.add("hidden");
          // Устгаж болохгүй бол өөр үйлдэл санал болгоно (жишээ нь «Цуцлах»)
          const blocked = cfg.deleteBlocked;
          if (err.status === 409 && blocked && blocked.show(row)) {
            altBtn.textContent = blocked.label;
            altBtn.classList.remove("hidden");
          }
        } finally {
          okBtn.disabled = false;
        }
      });

      altBtn.addEventListener("click", async () => {
        altBtn.disabled = true;
        try {
          replaceRow(await cfg.deleteBlocked.run(row));
          dlg.close();
          if (cfg.deleteBlocked.done) toast(cfg.deleteBlocked.done);
        } catch (err) {
          if (err.message !== "unauthorized") dlg.querySelector(".form-error").textContent = err.message;
          altBtn.disabled = false;
        }
      });
    }
  };
}

// ---------- Туслах функцууд ----------
function openDialog(html) {
  const dlg = document.createElement("dialog");
  dlg.innerHTML = html;
  document.body.appendChild(dlg);
  dlg.querySelector(".cancel")?.addEventListener("click", () => dlg.close());
  dlg.addEventListener("close", () => dlg.remove());
  dlg.showModal();
  dlg.querySelector("input, select")?.focus();
  return dlg;
}

function toast(msg, isError = false) {
  const el = document.createElement("div");
  el.className = "toast" + (isError ? " toast-error" : "");
  el.textContent = msg;
  document.body.appendChild(el);
  setTimeout(() => el.remove(), 3500);
}
