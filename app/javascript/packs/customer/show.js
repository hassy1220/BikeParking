window.addEventListener('load', () => {
    const uploader = document.querySelector('.uploader');
    uploader.addEventListener('change', (e) => {
      const file1 = uploader.files[0];
      // alert(file1);
      const file2 = uploader.files[1];
      // console.log(file2);
      if(file2 == undefined){
        document.querySelector('.avatar2').setAttribute('src', '../../assets/icon.png');
        // alert("aa");
      }
      // alert(file2);
      const file3 = uploader.files[2];
      if(file3 == undefined){
        document.querySelector('.avatar3').setAttribute('src', '../../assets/icon.png');
        // alert("aa");
      };
      // alert(file3);


      const reader1 = new FileReader();
      reader1.readAsDataURL(file1);
      reader1.onload = () => {
        const image = reader1.result;
        document.querySelector('.avatar1').setAttribute('src', image);
      }

      const reader2 = new FileReader();
      reader2.readAsDataURL(file2);
      reader2.onload = () => {
        const image = reader2.result;
        document.querySelector('.avatar2').setAttribute('src', image);
      }


      const reader3 = new FileReader();
      reader3.readAsDataURL(file3);
      reader3.onload = () => {
        const image = reader3.result;
        document.querySelector('.avatar3').setAttribute('src', image);
      }
    });
});