import ballerina/http;

http:ListenerConfiguration helloWorldEPConfig = {secureSocket: {key: {
            certFile: "public.cert",
            keyFile: "private.key"
        }}};

listener http:Listener securedEp = new (9091, helloWorldEPConfig);

@http:ServiceConfig {auth: [{
        ldapUserStoreConfig: {
            domainName: "avix.lk",
            connectionUrl: "ldap://localhost:636",
            connectionName: "cn=admin,dc=avix,dc=lk",
            connectionPassword: "avix123",
            userSearchBase: "ou=Users,dc=avix,dc=lk",
            userEntryObjectClass: "inetOrgPerson",
            userNameAttribute: "uid",
            userNameSearchFilter: "(&(objectClass=inetOrgPerson)(uid=?))",
            userNameListFilter: "(objectClass=inetOrgPerson)",
            groupSearchBase: ["ou=Groups,dc=avix,dc=lk"],
            groupEntryObjectClass: "groupOfNames",
            groupNameAttribute: "cn",
            groupNameSearchFilter: "(&(objectClass=groupOfNames)(cn=?))",
            groupNameListFilter: "(objectClass=groupOfNames)",
            membershipAttribute: "member",
            userRolesCacheEnabled: true,
            connectionPoolingEnabled: false,
            connectionTimeout: 5,
            readTimeout: 60
        },
        scopes: ["Admin"]
    }]}
service /admin on securedEp {
    resource function get .() returns string {

        return "Successful";
    }
}
// resource function get adminjwt(int id) returns json {
//     if true {
//         return http:Response;
//     } else {
//         jwt:IssuerConfig issuerConfig = {
//             username: "admin",
//             issuer: "ballerina",
//             audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
//             keyId: "NTAxZmMxNDMyZDg3MTU1ZGM0MzEzODJhZWI4NDNlZDU1OGFkNjFiMQ",
//             expTime: 3600,
//             signatureConfig: {config: {keyFile: "../resource/path/to/private.key"}}
//         };
//         string|jwt:Error jwt = jwt:issue(issuerConfig);
//         if (jwt is string) {
//             io:println("Issued JWT: ", jwt);
//         } else {
//             io:println("An error occurred while issuing the JWT: ", jwt.message());
//         }
//         jwt:ValidatorConfig validatorConfig1 = {
//             issuer: "ballerina",
//             audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
//             clockSkew: 60,
//             signatureConfig: {certFile: "../resource/path/to/public.crt"}
//         };
//         jwt:Payload|jwt:Error result = jwt:validate(checkpanic jwt, validatorConfig1);
//         if (result is jwt:Payload) {
//             io:println("Validated JWT Payload: ", result.toString());
//         } else {
//             io:println("An error occurred while validating the JWT: ", result.message());
//         }
//         jwt:ValidatorConfig validatorConfig2 = {
//             issuer: "ballerina",
//             audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
//             clockSkew: 60,
//             signatureConfig: {jwksConfig: {
//                     url: "https://localhost:20000/oauth2/jwks",
//                     clientConfig: {secureSocket: {cert: "../resource/path/to/public.crt"}}
//                 }}
//         };
//         result = jwt:validate(checkpanic jwt, validatorConfig2);
//         if (result is jwt:Payload) {
//             io:println("Validated JWT Payload: ", result.toString());
//         } else {
//             io:println("An error occurred while validating the JWT: ", result.message());
//         }
//         json jwks = {
//         "keys": [
//                 {
//                     "kty": "RSA",
//                     "e": "AQAB",
//                     "use": "sig",
//                     "kid": "NTAxZmMxNDMyZDg3MTU1ZGM0MzEzODJhZWI4NDNlZDU1" +
//                         "OGFkNjFiMQ",
//                     "alg": "RS256",
//                     "n": "AIFcoun1YlS4mShJ8OfcczYtZXGIes_XWZ7oPhfYCqhSIJ" +
//                         "nXD3vqrUu4GXNY2E41jAm8dd7BS5GajR3g1GnaZrSqN0w3b" +
//                         "jpdbKjOnM98l2-i9-JP5XoedJsyDzZmml8Xd7zkKCuDqZID" +
//                         "tZ99poevrZKd7Gx5n2Kg0K5FStbZmDbTyX30gi0_griIZyV" +
//                         "CXKOzdLp2sfskmTeu_wF_vrCaagIQCGSc60Yurnjd0RQiMW" +
//                         "A10jL8axJjnZ-IDgtKNQK_buQafTedrKqhmzdceozSot231" +
//                         "I9dth7uXvmPSjpn23IYUIpdj_NXCIt9FSoMg5-Q3lhLg6GK" +
//                         "3nZOPuqgGa8TMPs="
//                 }
//             ]
//     };
//     return jwks;
//     }
// }
// }
