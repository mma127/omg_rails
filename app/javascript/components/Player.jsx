import React from 'react';
import {useEffect, useState, useRef} from "react";
import axios from "axios";

export default function Player() {
    const [player, setPlayer] = useState(null)

    useEffect(() => {
        axios.get('/player')
            .then(response => setPlayer(response.data))
            .catch(error => console.log(error))
    }, [axios]);

    let playerElement = "";
    if (player) {
        playerElement = (
            <div>
                <h6>{player.name}</h6>
                <img src={player.avatar} alt="steam avatar"></img>
            </div>
        )
    }

    return playerElement
}