/*global Swiper*/
document.addEventListener('turbolinks:load', () => {
  var swiper = new Swiper('.swiper', {
    // 他のオプション...
    loop: true,
    effect: "fade",
    fadeEffect: {
      crossFade: true
    },
    autoplay: {
      delay: 3000, // 3秒ごと
      disableOnInteraction: false,
    },
    speed: 3000,
  });

  // Swiperにホバー時のイベントを追加
  document.querySelector('.swiper').addEventListener('mouseenter', () => {
    swiper.autoplay.stop();
  });

  document.querySelector('.swiper').addEventListener('mouseleave', () => {
    swiper.autoplay.start();
  });
});
