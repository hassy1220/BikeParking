// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";
import '@fortawesome/fontawesome-free/js/all';

Rails.start()
// Turbolinks.start()
ActiveStorage.start()


var i = 1
setInterval(() => {
    const images = document.querySelectorAll(".slider-image .top_img")
    i++
    const image = document.querySelector(".slider-image .active_img")
    image.classList.remove("active_img")
    if(i > images.length) {
      images[0].classList.add("active_img")
      i = 1
    } else {
      image.nextElementSibling.classList.add("active_img")
    }
}, 2000)
