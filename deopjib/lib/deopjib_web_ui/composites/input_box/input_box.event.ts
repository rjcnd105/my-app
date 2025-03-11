window.addEventListener("input_box/clear-input", (e) => {
  const buttonEl = e.target as HTMLButtonElement;
  const inputEl = buttonEl.previousElementSibling;

  if (inputEl instanceof HTMLInputElement) {
    inputEl.value = "";
    inputEl.dispatchEvent(new Event("change", { bubbles: true }));
    inputEl.focus();
  }
});
