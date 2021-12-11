import React from 'react'
import {useEffect, useState, useRef} from "react";

import axios from "axios"

export default function DoctrineList() {
    const [doctrines, setDoctrines] = useState([]);

    useEffect(() => {
        axios.get('/api/doctrines')
            .then(response => setDoctrines(response.data))
            .catch(error => console.log(error))
    }, [axios]);

    let doctrinesElement = []
    for (let doc of doctrines) {
        doctrinesElement.push(
            <div key={doc.id}>
                <h6>{doc.display_name}</h6>
            </div>
        )
    }

    return doctrinesElement
}