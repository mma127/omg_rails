import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const companiesAdapter = createEntityAdapter()

const initialState = companiesAdapter.getInitialState({
  availableUnits: [],
  availableUnitsStatus: "idle",
  loadingAvailableUnitsError: null,
  creatingStatus: "idle",
  creatingError: null,
  deletingError: null
})

export const fetchCompanies = createAsyncThunk("companies/fetchCompanies", async () => {
  const response = await axios.get("/companies")
  return response.data
})

export const fetchCompanyAvailableUnits = createAsyncThunk("companies/fetchCompanyAvailableUnits", async ({ companyId }) => {
  const response = await axios.get(`/companies/${companyId}/available_units`)
  return response.data
})

export const createCompany = createAsyncThunk("companies/createCompany", async ({ name, doctrineId }) => {
  const response = await axios.post("/companies", { name, doctrineId })
  return response.data
})

export const deleteCompanyById = createAsyncThunk("companies/deleteCompany", async ({ companyId }) => {
  const response = await axios.delete(`/companies/${companyId}`)
  return response.data
})

const companiesSlice = createSlice({
  name: "companies",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchCompanies.fulfilled, (state, action) => {
        companiesAdapter.setAll(state, action.payload)
      })

      .addCase(fetchCompanyAvailableUnits.pending, (state, action) => {
        state.availableUnitsStatus = "pending"
        state.loadingAvailableUnitsError = null
      })
      .addCase(fetchCompanyAvailableUnits.fulfilled, (state, action) => {
        state.availableUnits = action.payload
        state.availableUnitsStatus = "idle"
      })
      .addCase(fetchCompanyAvailableUnits.rejected, (state, action) => {
        state.availableUnitsStatus = "idle"
        state.loadingAvailableUnitsError = action.error.message
      })

      .addCase(createCompany.pending, (state) => {
        state.creatingStatus = "pending"
        state.creatingError = null
      })
      .addCase(createCompany.fulfilled, (state, action) => {
        state.creatingStatus = "fulfilled"
        companiesAdapter.setOne(state, action.payload)
      })
      .addCase(createCompany.rejected, (state, action) => {
        state.creatingStatus = "rejected"
        state.creatingError = action.error.message
      })

      .addCase(deleteCompanyById.pending, (state, action) => {
        state.deletingError = null
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

export const selectAvailableUnits = state => state.companies.availableUnits
export const selectAvailableUnitsStatus = state => state.companies.availableUnitsStatus