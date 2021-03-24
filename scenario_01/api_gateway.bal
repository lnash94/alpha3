import ballerina/http;
import ballerina/jwt;
import ballerina/io;

http:ListenerConfiguration helloWorldEPConfig = {secureSocket: {key: {
            certFile: "public.cert",
            keyFile: "private.key"
        }}};

listener http:Listener securedEp = new (9091, helloWorldEPConfig);
listener http:Listener securedEpClient = new (9443);

# Admin service   
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

    # This for  issues a self-signed JWT signed  
    # + return - Return Value Description  
    resource function get adminjwt() returns http:Response {
        http:Response response = new;

        jwt:IssuerConfig issuerConfig = {
            username: "admin",
            issuer: "ballerina",
            audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
            keyId: "NTAxZmMxNDMyZDg3MTU1ZGM0MzEzODJhZWI4NDNlZDU1OGFkNjFiMQ",
            expTime: 3600,
            signatureConfig: {config: {keyFile: "private.key"}}
        };
        string|jwt:Error jwt = jwt:issue(issuerConfig);
        if (jwt is string) {
            io:println("Issued JWT: ", jwt);
            //call admin micro service for validating the service    
            return validatejwt(jwt);
        } else {
            io:println("An error occurred while issuing the JWT: ", jwt.message());
            return response;
        }
    }
}

# Customer inventory handle
service /'order on securedEpClient {
    resource function get .() returns http:Response|error {
        http:Response response = new;
        jwt:IssuerConfig issuerConfig = {
            username: "admin",
            issuer: "ballerina",
            audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
            keyId: "NTAxZmMxNDMyZDg3MTU1ZGM0MzEzODJhZWI4NDNlZDU1OGFkNjFiMQ",
            expTime: 3600,
            signatureConfig: {config: {keyFile: "private.key"}}
        };
        string|jwt:Error jwt = jwt:issue(issuerConfig);
        if (jwt is string) {
            io:println("Issued JWT: ", jwt);
            //call admin micro service for validating the service    
            return validate(jwt);
        } else {
            io:println("An error occurred while issuing the JWT: ", jwt.message());
            response.statusCode = 401;
            return response;
        }
    }
}
