/*global Swiper*/
document.addEventListener('turbolinks:load', () => {
  const swiper = new Swiper('.swiper-main-visual', {
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

  const swiper2 = new Swiper('.swiper-about-top', {
    allowTouchMove: false, //タッチ無効化
    slidesPerView: 10, //表示する画像枚数
    spaceBetween: 32, //画像の間
    loop: true, //自動再生
    speed: 8000, //スピード
    autoplay: { //ディレイ0でスムーズに
      delay: 0,
    },
  });

  const swiper3 = new Swiper('.swiper-about-bottom', {
    allowTouchMove: false,
    slidesPerView: 10,
    spaceBetween: 32,
    loop: true,
    speed: 8000,
    autoplay: {
      delay: 0,
      reverseDirection: true,
    },
  });

  const swiper4 = new Swiper('.swiper-complete', {
    loop: true,
    effect: "fade", //切り替え方法をfadeに変更
    fadeEffect: {
      crossFade: true
    },
    autoplay: {
      delay: 2000, // 3秒間表示
      disableOnInteraction: false,
    },
    speed: 2000, //3秒間で切り替え
  });
});