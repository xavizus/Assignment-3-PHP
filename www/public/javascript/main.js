console.log("Hello, I am loaded!");

window.addEventListener('click', (event) => {
    if(event.target.id == "skickaPengar") {

        $username = document.getElementById('username');

        fetch('localhost/api.php?transfer=', {
            method: "POST",
            data: {
                "fromUserId": 1,
                "toUserId": 3,
                "amount": 300
            }
        });
    }
});