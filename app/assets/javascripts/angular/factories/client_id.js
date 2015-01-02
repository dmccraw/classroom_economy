// app.factory("clientId", function clientIdFactory() {
//   return "abcdef123456";
// });

app.factory('apiToken', ['clientId',
    function apiTokenFactory(clientId) {
        var encrypt = function(data1, data2) {
            return (data1 + ":" + data2).toUpperCase();
        };

        var secret = window.localStorage.getItem('app.secret');
        var apiToken = encrypt(clientId, secret);

        return apiToken;
    }
]);