 window.onload = function(){
   function slidshow() {
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
   };
  slidshow();
 };
