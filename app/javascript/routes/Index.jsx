import React from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Home from "../components/Home";
import Doctrines from "../components/Doctrines";
import Doctrine from "../components/Doctrine";

export default (
    <BrowserRouter>
        <Routes>
            <Route path="/" exact element={<Home />} >

            </Route>
            <Route path="/doctrines" element={<Doctrines />}>
            </Route>
            <Route path="/doctrines/:doctrineId" element={<Doctrine />} />

            <Route path="*" element={<main style={{ padding: "1rem" }}><p>Nothing here</p></main>} />
        </Routes>
    </BrowserRouter>
);