let URL = `${location.protocol}//${window.location.host}`;
let APIURL = `${URL}/api.php`;
document.addEventListener('DOMContentLoaded', event => {

    populateToAccount();
    populateProfile();
    document.addEventListener('click', (event) => {
        event.preventDefault()
        event.stopPropagation();
        if(event.target.id == "sendMoney") {
            let sendType = document.getElementById('sendType').value;
            let to = null;
            let selection = document.getElementById('to_account');
            let toSelector = selection.options[selection.selectedIndex];
            switch(sendType) {
                case "swish":
                    to = toSelector.dataset['phonenumber'];
                    break;
                case "bank":
                    to = toSelector.dataset['user_accountnumber'];
                    break;
                case "creditcard":
                    to = toSelector.dataset['creditcard'];
                    break;
            }
            if(to == null) {
                return;
            }

            let amount = document.getElementById('amount').valueAsNumber;
            
            fetch(`${APIURL}?Transaction&type=${sendType}&to=${to}&amount=${amount}`)
            .then(response => response.json())
            .then(result => {
                if (result.info.code == "OK") {
                    if(confirm("YOU HAVE SUCESSFULLY TRANSFERD MONEY!")) {
                        window.location.replace(URL);
                    } else {
                        window.location.replace(URL);
                    }
                }
                else if(typeof result.img !== 'undefined') {
                    document.getElementById('message').innerHTML= result.img;
                    document.getElementById('message').append(result.info.message);
                }
                else {
                    alert("Something went wrong!");
                }
            });
        }
    });

});

function populateToAccount() {
    fetch(`${APIURL}?getAllUsers`).
    then(result => {return result.json()}).
    then(results => {
        for(account of results) {
            let option = document.createElement("option");
            option.setAttribute('data-user_id',account.user_id);
            option.setAttribute('data-user_accountNumber',account.user_accountNumber);
            option.setAttribute('data-phoneNumber',account.phoneNumber);
            option.setAttribute('data-creditCard',account.creditCard);
            let content = `${account.firstName} ${account.lastName}`;

            option.append(content);

            document.getElementById('to_account').append(option);
        }
    });
}

function populateProfile() {
    fetch(`${APIURL}?getBalanceAndCurrencyByUserId`).
    then(result => {return result.json()}).
    then(results => {
        document.getElementById('balance').append(results['balance']);
        document.getElementById('currency').append(results['currency']);
    });
}