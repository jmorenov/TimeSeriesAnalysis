export class User {
    username: string;
    email: string;
    name: string;
    authToken: string;

    constructor(username: string, email: string, name: string) {
        this.username = username;
        this.email = email;
        this.name = name;
    }
}