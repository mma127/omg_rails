import React from 'react'
import {useEffect, useState, useRef} from "react";
import axios from "axios"

export default function CompanyForm() {
    const [name, setName] = useState("")
    const [doctrineId, setDoctrineId] = useState("")

    const handleSubmit = (event) => {
        event.preventDefault()
        console.log(`Submitted with ${name} and ${doctrineId}`)
        axios.post('/api/companies',
            {
                'name': name,
                'doctrineId': doctrineId
            }).then(response => console.log(response.data)).catch(error => console.log(error))
    }

    return (
        <form onSubmit={handleSubmit}>
            <label>Name:
                <input type="text" value={name} onChange={(e) => setName(e.target.value)} />
            </label>
            <label>DoctrineId:
                <input type="text" value={doctrineId} onChange={(e) => setDoctrineId(e.target.value)} />
            </label>
            <input type="submit" />
        </form>
    )
}