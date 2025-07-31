document.addEventListener('turbo:load', function () {
  document.addEventListener('change', function (event) {
    let image_upload = document.querySelector('#micropost_image');
    const size_in_megabytes = image_upload.files[0].size / 1024 / 1024;
    const MAX_IMG_SIZE_MB = parseFloat(image_upload.dataset.maxFileSizeMb);
    if (size_in_megabytes > MAX_IMG_SIZE_MB) {
      alert(I18n.t('microposts.image_too_large'));
      image_upload.value = '';
    }
  });
});
