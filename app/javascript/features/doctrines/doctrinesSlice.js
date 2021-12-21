import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const doctrinesAdapter = createEntityAdapter()

const initialState = doctrinesAdapter.getInitialState()

export const fetchDoctrines = createAsyncThunk("doctrines/fetchDoctrines", async () => {
  const response = await axios.get("/doctrines")
  return response.data
})

const doctrinesSlice = createSlice({
  name: "doctrines",
  initialState,
  reducers:{},
  extraReducers(builder) {
    builder.addCase(fetchDoctrines.fulfilled, (state, action) => {
      doctrinesAdapter.setAll(state, action.payload)
    })
  }
})

export default doctrinesSlice.reducer

export const {
  selectAll: selectAllDoctrines,
  selectById: selectDoctrineById
} = doctrinesAdapter.getSelectors(state => state.doctrines)
