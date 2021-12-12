import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const companiesAdapter = createEntityAdapter()

const initialState = companiesAdapter.getInitialState({
  creatingStatus: "idle",
  creatingError: null,
  deletingError: null
})

export const fetchCompanies = createAsyncThunk("companies/fetchCompanies", async () => {
  const response = await axios.get("/api/companies")
  return response.data
})

export const createCompanies = createAsyncThunk("companies/createCompanies", async ({ alliedCompany, axisCompany }) => {
  const response = await axios.post("/api/companies", { allies: alliedCompany, axis: axisCompany })
  return response.data
})

export const deleteCompanyById = createAsyncThunk("companies/deleteCompany", async ({ companyId }) => {
  const response = await axios.delete(`/api/companies/${companyId}`)
  return response.data
})

const companiesSlice = createSlice({
  name: "companies",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchCompanies.fulfilled, (state, action) => {
        companiesAdapter.setAll(state, action.payload.data)
      })
      .addCase(createCompanies.pending, (state) => {
        state.creatingStatus = "pending"
      })
      .addCase(createCompanies.fulfilled, (state, action) => {
        state.creatingStatus = "fulfilled"
        companiesAdapter.upsertMany(state, action.payload.data)
      })
      .addCase(createCompanies.rejected, (state, action) => {
        state.creatingStatus = "rejected"
        state.creatingError = action.error.message
      })
      .addCase(deleteCompanyById.fulfilled, (state, action) => {
        companiesAdapter.removeOne(state, action.payload)
      })
      .addCase(deleteCompanyById.rejected, (state, action) => {
        state.deletingError = action.error.message
      })
  }
})

export default companiesSlice.reducer

export const {
  selectAll: selectAllCompanies,
  selectById: selectCompanyById
} = companiesAdapter.getSelectors(state => state.companies)
