import type { Hook } from "phoenix_live_view";

type ShowToastProps = {
  content: string;
};
export class ToastManager {
  container: null | HTMLElement = null;
  template: null | HTMLTemplateElement = null;
  config: {
    duration?: number;
    maxCount?: number;
  } = {};
  toastMap = new Map<
    string,
    { el: HTMLElement; timer: number | null; time: number }
  >();

  initialize() {
    this.container = document.getElementById("toast-container");
    this.template = document.getElementById(
      "toast-template",
    ) as HTMLTemplateElement;

    this.config = {
      duration: Number(this.container?.dataset.duration),
      maxCount: Number(this.container?.dataset.maxCount),
    };

    // @ts-ignore
    window.addEventListener("toast/open", (e) => this.showToast(e));

    // 글로벌 객체로 노출
    // window.toast = this.showToast.bind(this);
  }

  showToast(e: Event & { detail: { message: string } }) {
    if (!this.container || !this.template || !this.config) return;

    // 토스트 ID 생성
    const id = `toast-${Date.now()}`;

    const toastEl = this.template.content.firstElementChild?.cloneNode(
      true,
    ) as HTMLElement;

    if (toastEl) {
      toastEl.innerText = e.detail.message;
    }

    toastEl.onclick = () => {
      this.dismissToast(id);
    };

    toastEl.style.opacity = "0";
    toastEl.style.height = "";
    toastEl.style.transform = "translateY(100%)";

    this.container.appendChild(toastEl);

    const duration = Number(this.config.duration);
    // 애니메이션 시작 (약간의 지연으로 DOM에 추가된 후 실행)
    setTimeout(() => {
      toastEl.style.opacity = "1";
      toastEl.style.transform = "translateY(0)";
    }, 10) as unknown as number;

    this.toastMap.set(id, {
      el: toastEl,
      timer: null,
      time: Number(this.config.duration),
    });

    setTimeout(() => {
      this.dismissToast(id);
    }, duration);

    return id;
  }

  dismissToast(id: string) {
    const toastData = this.toastMap.get(id);
    if (!toastData) return;

    const { el, timer: before_timer, time } = toastData;

    if (before_timer) clearTimeout(before_timer);
    this.toastMap.set(id, {
      ...toastData,
      timer: null,
    });

    el.addEventListener("transitionend", () => {
      if (el.parentNode) {
        el.parentNode.removeChild(el);
      }
      this.toastMap.delete(id);
    });
    // 사라지는 애니메이션
    el.style.opacity = "0";
    el.style.transform = "translateX(-100%)";
  }
}

const toastManager = new ToastManager();

export const ToastHook = {
  mounted() {
    toastManager.initialize();
  },
} as const satisfies Hook;
