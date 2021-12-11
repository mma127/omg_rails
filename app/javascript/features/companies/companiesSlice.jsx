import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const companiesAdapter = createEntityAdapter()

const initialState = companiesAdapter.getInitialState()

export const fetchCompanies = createAsyncThunk("companies/fetchCompanies", async () => {
  const response = await axios.get("/api/companies")
  return response.data
})

const companiesSlice = createSlice({
  name: "companies",
  initialState,
  reducers:{},
  extraReducers(builder) {
    builder.addCase(fetchCompanies.fulfilled, (state, action) => {
      companiesAdapter.setAll(state, action.payload)
    })
  }
})

export default companiesSlice.reducer

export const {
  selectAll: selectAllCompanies,
  selectById: selectCompanyById
} = companiesAdapter.getSelectors()


