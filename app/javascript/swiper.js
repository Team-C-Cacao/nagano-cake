/*global Swiper*/
document.addEventListener('turbolinks:load', () => {
  const swiper = new Swiper('.swiper1', {
    loop: true,
    effect: "fade", //切り替え方法をfadeに変更
    fadeEffect: {
      crossFade: true
    },
    autoplay: {
      delay: 3000, // 3秒間表示
      disableOnInteraction: false,
    },
    speed: 3000, //3秒間で切り替え
  });

  const swiper2 = new Swiper('.swiper2', {
    allowTouchMove: false, //タッチ無効化
    slidesPerView: 10, //表示する画像枚数
    spaceBetween: 120, //画像の間
    loop: true, //自動再生
    speed: 8000, //スピード
    autoplay: { //ディレイ0でスムーズに
      delay: 0,
    },
  });

  const swiper3 = new Swiper('.swiper3', {
    allowTouchMove: false,
    slidesPerView: 10,
    spaceBetween: 120,
    loop: true,
    speed: 8000,
    autoplay: {
      delay: 0,
      reverseDirection: true,
    },
  });
});
