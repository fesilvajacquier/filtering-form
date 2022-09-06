import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("filtering_form controller connected")
    this.element.querySelectorAll("input").forEach( (input) => {
      input.addEventListener("input", this.debounce(() => this.submit()))
    })
  }

  // private

  debounce(func, timeout = 500) {
    let timer;
    return (...args) => {
      clearTimeout(timer);
      timer = setTimeout(() => { func.apply(this, args); }, timeout);
    };
  }

  submit() {
    this.element.requestSubmit()
  }
}
