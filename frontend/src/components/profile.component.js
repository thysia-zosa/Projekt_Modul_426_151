import React, { Component } from "react";
import AuthService from "../services/auth.service";
import { withRouter, Route, Switch } from 'react-router-dom';
import {Nav, NavDropdown, Navbar, Button} from "react-bootstrap";

import Entries from './entries.component';

class Profile extends Component {
    constructor(props) {
        super(props);

        this.state = {
            currentUser: AuthService.getCurrentUser()
        };
    }

    logOut = () => {
        this.props.logOut();
    };

    render() {

        return (
            <div style={{whiteSpace: "nowrap"}}>
                <Navbar bg="light" variant="light" sticky={"top"}>
                    <Navbar.Brand>
                        <img
                            alt="Logo"
                            src="https://www.flaticon.com/svg/static/icons/svg/62/62834.svg"
                            width="30"
                            height="30"
                            className="d-inline-block align-top"
                        />{' '}
                        PUNCHCLOCK
                    </Navbar.Brand>
                    <Nav className="mr-auto" defaultActiveKey={"entries"}>
                        <Nav.Link eventKey="entries" href={"localhost:8081/profile/entries"}>
                                <i className="fas fa-stopwatch"/> Entries
                        </Nav.Link>
                        <NavDropdown title={"Users"} id="basic-nav-dropdown">
                            <NavDropdown.Item eventKey={"manage"} href={"localhost:8081/profile/settings"}>
                                <i className="fas fa-user-cog"/>  Manage
                            </NavDropdown.Item>
                        </NavDropdown>
                    </Nav>
                    <Nav>
                        <Nav.Item >
                            <Button variant={"link"} size={"sm"} onClick={this.logOut}>
                                <i className="fas fa-sign-out-alt"/>  Sign-Out
                            </Button>
                        </Nav.Item>
                    </Nav>
                </Navbar>
                <Switch>
                    <Route exact path={"/profile/entries"}>
                        <Entries />
                    </Route>
                    <Route exact path={"/profile/settings"}>
                        <Entries />
                    </Route>
                </Switch>
            </div>
        );
    }
}

export default withRouter(Profile);
