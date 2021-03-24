import ballerina/http;
import ballerina/log;
import ballerina/test;

http:Client securedEP = check new("https://localhost:9443", {
    auth: {
        tokenUrl: "https://localhost:9443/oauth2/token",
        clientId: "s6BhdRkqt3",
        clientSecret: "7Fjfp0ZBr1KtDRbnfVdmIw",
        scopes: ["Customer"],
        clientConfig: {
            secureSocket: {
                cert: "../public.cert"
            }
        }
    },
    secureSocket: {
        cert: "../public.cert"
    }
});

@test:Config {}
function getClientCall() {
    var response = securedEP->get("/order");
    if (response is http:Response) {
        log:printInfo(response.statusCode.toString());
    } else {
        log:printError("Failed to call the endpoint.", 'error = response);
    }

}
