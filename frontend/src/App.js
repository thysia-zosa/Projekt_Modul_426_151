import React, { Component } from "react";
import { withRouter, Redirect, Route, Link } from "react-router-dom";
import Div100vh from 'react-div-100vh'
import FadeIn from 'react-fade-in';

import AuthService from "./services/auth.service";
import LoginPage from './components/login.component';
import ProfilePage from './components/profile.component'
import RegisterPage from './components/register.component';
import Particles from './components/particles.component';

import 'bootstrap/dist/css/bootstrap.min.css';
import "./App.css";
import {Button} from 'react-bootstrap';

class App extends Component {
    constructor(props) {
        super(props);
        this.logOut = this.logOut.bind(this);

        this.state = {
            currentUser: undefined,
            register: false
        };
    }

    logOut = () => {
        AuthService.logout();
        this.setState({currentUser: undefined})
    };

    setCurrentUser = () => {
        this.setState({currentUser: AuthService.getCurrentUser})
    };

    render() {
        const { currentUser } = this.state;
        if (currentUser === undefined && this.state.register === false) {
            return (
                <>
                    <Redirect to={"/login"} />
                    <Particles />
                    <Div100vh className={"div100"}>
                        <FadeIn>
                            <div className={"main-wrapper"} style={{opacity: "1"}}>
                                <Route exact path={"/login"}>
                                    <LoginPage setCurrentUser={this.setCurrentUser}/>
                                </Route>
                                <Link replace={true} to={"/register"}>
                                    <Button style={{textTransform: "capitalize"}} block variant="link" size={"btn-mini"} onClick={() => this.setState({register: true})}>
                                        click here to sign up  <i className="fas fa-arrow-right" />
                                    </Button>
                                </Link>
                            </div>
                        </FadeIn>
                    </Div100vh>
                </>
            )
        }
        if (currentUser !== undefined) {
            return (
                <>
                    <Redirect push to={"/profile/entries"} />
                    <Route path={"/profile"}>
                        <ProfilePage logOut={this.logOut} />
                    </Route>
                </>
            )
        }
        return (
          <>
              <Particles />
              <Div100vh className={"div100"}>
                  <FadeIn>
                      <div className={"main-wrapper"}>
                          <Route exact path={"/register"} component={RegisterPage}/>
                          <Button style={{textTransform : "capitalize"}} block variant="link" size={"btn-mini"} onClick={() => this.setState({register: false})}>
                              <i className="fas fa-arrow-left" />  get back to the login
                          </Button>
                      </div>
                  </FadeIn>
              </Div100vh>
          </>
        );
    }
}

export default withRouter(App);
