import React from "react";
import {Link} from "react-router-dom";

class Doctrines extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            doctrines: []
        }
    }

    componentDidMount() {
        const url = "/api/v1/doctrines/index";
        fetch(url).then(response => {
            if (response.ok) {
                return response.json();
            }
            throw new Error("Not ok");
        })
            .then(response => this.setState({doctrines: response}))
            .catch(() => this.props.history.push("/"));
    }

    render() {
        const {doctrines} = this.state;
        const allDoctrines = doctrines.map((doctrine, index) => (
            <div key={index} className="col-md-6 col-lg-4">
                <div className="card mb-4">
                    <div className="card-body">
                        <h5 className="card-title">{doctrine.name}</h5>
                        <Link
                            to={`/doctrines/${doctrine.id}`}
                            key={doctrine.id}
                            className="btn custom-button"
                        >
                            View doctrine
                        </Link>
                    </div>
                </div>
            </div>
        ));

        const noDoctrines = (
            <div className="vw-100 vh-50 d-flex align-items-center justify-content-center">
                <h4>
                    No doctrines yet. Why not <Link to="/new_doctrine">create one</Link>
                </h4>
            </div>
        );

        return (
            <>
                <section className="jumbotron jumbotron-fluid text-center">
                    <div className="container py-5">
                        <h1 className="display-4">Doctrines</h1>
                        <p className="lead text-muted">
                            We’ve pulled together our most popular doctrines, our latest
                            additions, and our editor’s picks, so there’s sure to be something
                            tempting for you to try.
                        </p>
                    </div>
                </section>
                <div className="py-5">
                    <main className="container">
                        <div className="text-right mb-3">
                            <Link to="/doctrine" className="btn custom-button">
                                Create New Doctrine
                            </Link>
                        </div>
                        <div className="row">
                            {doctrines.length > 0 ? allDoctrines : noDoctrines}
                        </div>
                        <Link to="/" className="btn btn-link">
                            Home
                        </Link>
                    </main>
                </div>
            </>
        )
    }
}

export default Doctrines;