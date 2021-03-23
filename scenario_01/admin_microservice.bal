import ballerina/http;
import ballerina/jwt;
import ballerina/io;

# Description
#
# + jwt - Parameter string type jwt token
# + return - Return Value http response  
public function validatejwt(string jwt) returns http:Response {
    http:Response outResponse = new;
    jwt:ValidatorConfig validatorConfig2 = {
        issuer: "ballerina",
        audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
        clockSkew: 60,
        signatureConfig: {jwksConfig: {
                url: "https://localhost:9443/oauth2/token",
                clientConfig: {secureSocket: {cert: "public.crt"}}
            }}
    };
    jwt:Payload|jwt:Error result = jwt:validate(jwt, validatorConfig2);
    if (result is jwt:Payload) {
        io:println("Validated JWT Payload: ", result.toString());
        // return responses
        return
    } else {
        io:println("An error occurred while validating the JWT: ", result.message());
    }
}
