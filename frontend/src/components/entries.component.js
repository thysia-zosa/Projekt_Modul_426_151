import React, { Component } from "react";
import AuthService from "../services/auth.service";
import UserService from '../services/user.service';
import Entry from "./entry.modal.component";
import {Button, Card, Table, Container, Row, Col} from "react-bootstrap";

class Entries extends Component {
    constructor(props) {
        super(props);

        this.getData = this.getData.bind(this);

        this.state = {
            currentUser: AuthService.getCurrentUser(),
            data: []
        };
    }

    componentDidMount() {
        this.getData();
    }

    getData() {
        UserService.getEntries().then(
            response => {
                this.setState({
                    data: response.data
                });
            },
            error => {
                let resMessage = (error.response && error.response.data && error.response.data.message) || error.message || error.toString();
                if (resMessage.includes("403")) {
                    resMessage = "You are not authorized";
                }
                this.setState({
                    message: resMessage
                });
            }
        );
    }

    deleteEntry(id) {
        console.log(id);
        UserService.deleteEntry(id).then(
            () => {
                this.getData();
            },
            error => {
                let resMessage = (error.response && error.response.data && error.response.data.message) || error.message || error.toString();
                if (resMessage.includes("403")) {
                    resMessage = "You are not authorized";
                }
                if (resMessage.includes("404")) {
                    resMessage = "Entry not found";
                }
                this.setState({
                    message: resMessage
                });
            }
        );
    }

    parseDateTime(dateTime) {
        const date = dateTime.substr(0, dateTime.indexOf("T", 0));
        const time = dateTime.substr(dateTime.indexOf("T", 0) + 1, dateTime.length);
        return(
            <>
                {date}<br/>{time}
            </>
        )
    }

    render() {

        return (
            <Container fluid style={{padding: "2rem"}}>
                <Row>
                    <Col style={{marginBottom: "1rem"}}>
                        <Entry show={false} getData={this.getData}/>
                    </Col>
                </Row>
                <Row>
                    <Col>
                        <Card bg={"light"} style={{padding: "0"}}>
                            <Card.Header as="h5">
                                    Entries
                            </Card.Header>
                            <Card.Body>
                                <Table responsive borderless>
                                    <thead>
                                        <tr>
                                            <th style={{textAlign: "center"}}>Starttime</th>
                                            <th style={{textAlign: "center"}}>Endtime</th>
                                            <th>Username</th>
                                            <th>Category</th>
                                            <th>Note</th>
                                            <th/>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {this.state.data.map((item, index) => (
                                            <tr key={index}>
                                                <td style={{textAlign: "center"}}>{this.parseDateTime(item.checkIn)}</td>
                                                <td style={{textAlign: "center"}}>{this.parseDateTime(item.checkOut)}</td>
                                                <td>{item.applicationUser.username}</td>
                                                <td>{item.category.name}</td>
                                                <td>not yet implemented</td>
                                                <td>
                                                    <Button variant={"outline-dark"} size={"sm"}>
                                                        <i className="far fa-edit" />
                                                    </Button>
                                                    <Button
                                                        variant={"outline-danger"}
                                                        size={"sm"}
                                                        style={{marginLeft: "4px"}}
                                                        value={item.id}
                                                        onClick={() => this.deleteEntry(item.id)}>
                                                        <i className="far fa-trash-alt" />
                                                    </Button>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </Table>
                            </Card.Body>
                        </Card>
                    </Col>
                </Row>
            </Container>
        );

    }

}

export default Entries;