import React from "react";
import {useEffect, useState, useRef} from "react";
import { Link, useParams } from "react-router-dom";

export default function Doctrine() {
    const [doctrine, setDoctrine] = useState({});
    let { doctrineId } = useParams();

    useEffect(() => {
        fetch(`/api/v1/doctrines/${doctrineId}`).then(response => response.json())
            .then(setDoctrine);
    }, []);

    return (
        <div className="container py-5">
            <div className="row">
                <h5 className="mb-2">{doctrine.display_name}</h5>
            </div>
            <Link to="/doctrines" className="btn btn-link">
                Back to doctrines
            </Link>
        </div>
    )
}
