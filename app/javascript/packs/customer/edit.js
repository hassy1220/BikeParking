window.addEventListener('load', () => {
    const uploader = document.querySelector('.uploader');
    uploader.addEventListener('change', (e) => {
      const file1 = uploader.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file1);
      reader.onload = () => {
        const image = reader.result;
        document.querySelector('.avatar1').setAttribute('src', image);
      }
    });
});