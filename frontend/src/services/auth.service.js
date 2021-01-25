import axios from "axios";

const API_URL = "http://localhost:8081/";

class AuthService {
    login(username, password) {
        return axios
            .post(API_URL + "login", {
                username,
                password
            })
            .then(response => {
                if (response.headers.authorization) {
                    localStorage.setItem("user", JSON.stringify(response.headers.authorization));
                }

                return response.headers.authorization;
            });
    }

    logout() {
        localStorage.removeItem("user");
    }

    register(username, email, password) {
        return axios.post(API_URL + "users/sign-up", {
            username,
            email,
            password
        });
    }

    getCurrentUser() {
        return JSON.parse(localStorage.getItem('user'));
    }
}

export default new AuthService();