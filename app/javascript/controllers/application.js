import { Application } from "@hotwired/stimulus"
import toastr from "toastr";

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

toastr.options = {
  closeButton: true,
  progressBar: true,
  positionClass: "toast-top-right",
};

window.toastr = toastr;

export { application }
