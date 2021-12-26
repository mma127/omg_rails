import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const companiesAdapter = createEntityAdapter()

const initialState = companiesAdapter.getInitialState({
  loadingCompanyStatus: "idle",
  loadingCompanyError: null,
  creatingStatus: "idle",
  creatingError: null,
  deletingError: null
})

/**
 * Fetch all companies for the player. High level data only for company selection
 */
export const fetchCompanies = createAsyncThunk("companies/fetchCompanies", async () => {
  const response = await axios.get("/companies")
  return response.data
})

/**
 * Fetch data for a specific company for the player.
 * Includes available units, squads, unlocks to populate company manager
 */
export const fetchCompanyById = createAsyncThunk("companies/fetchCompanyById", async ({ companyId }) => {
  const response = await axios.get(`/companies/${companyId}`)
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

      .addCase(fetchCompanyById.pending, (state) => {
        state.loadingCompanyStatus = "pending"
        state.loadingCompanyError = null
      })
      .addCase(fetchCompanyById.fulfilled, (state, action) => {
        state.loadingCompanyStatus = "fulfilled"
        companiesAdapter.upsertOne(state, action.payload)
      })
      .addCase(fetchCompanyById.rejected, (state, action) => {
        state.loadingCompanyStatus = "rejected"
        state.loadingCompanyError = action.error.message
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
