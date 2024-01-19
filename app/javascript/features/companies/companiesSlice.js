import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"
import { purchaseUnlock, refundUnlock } from "./manage/unlocks/companyUnlocksSlice";

const companiesAdapter = createEntityAdapter()

const initialState = companiesAdapter.getInitialState({
  loadingCompanyStatus: "idle",
  loadingCompanyError: null,
  loadingCompaniesError: null,
  creatingStatus: "idle",
  creatingError: null,
  deletingError: null,
  currentCompany: null,
  needsRefresh: false //Bad hack for triggering another action
})

/**
 * Fetch all companies for the player. High level data only for company selection
 */
export const fetchCompanies = createAsyncThunk(
  "companies/fetchCompanies",
  async () => {
    try {
      const response = await axios.get("/companies")
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  })

/**
 * Fetch data for a specific company for the player.
 * Includes available units, squads, unlocks to populate company manager
 */
export const fetchCompanyById = createAsyncThunk(
  "companies/fetchCompanyById",
  async ({ companyId }, { rejectWithValue }) => {
    try {
      const response = await axios.get(`/companies/${companyId}`)
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  })

export const createCompany = createAsyncThunk(
  "companies/createCompany",
  async ({ name, doctrineId }, { rejectWithValue }) => {
    try {
      const response = await axios.post("/companies", { name, doctrineId })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  })

export const deleteCompanyById = createAsyncThunk(
  "companies/deleteCompany",
  async ({ companyId }, { rejectWithValue }) => {
    try {
      const response = await axios.delete(`/companies/${companyId}`)
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  })

const companiesSlice = createSlice({
  name: "companies",
  initialState,
  reducers: {
    addCost(state, action) {
      const { id, pop, man, mun, fuel } = action.payload
      const company = state.entities[id]
      if (company) {
        company.pop += parseFloat(pop)
        company.man -= man
        company.mun -= mun
        company.fuel -= fuel
      }
    },
    removeCost(state, action) {
      const { id, pop, man, mun, fuel } = action.payload
      const company = state.entities[id]
      if (company) {
        company.pop -= parseFloat(pop)
        company.man += man
        company.mun += mun
        company.fuel += fuel
      }
    },
    setCurrentCompany(state, action) {
      state.currentCompany = action.payload
    }
  },
  extraReducers(builder) {
    builder
      .addCase(fetchCompanies.fulfilled, (state, action) => {
        companiesAdapter.setAll(state, action.payload)
      })
      .addCase(fetchCompanies.rejected, (state, action) => {
        if (!_.isNil(action.payload)) {
          state.loadingCompaniesError = action.payload.error
        }
      })

      .addCase(fetchCompanyById.pending, (state) => {
        state.loadingCompanyStatus = "pending"
        state.loadingCompanyError = null
      })
      .addCase(fetchCompanyById.fulfilled, (state, action) => {
        state.loadingCompanyStatus = "fulfilled"
        state.needsRefresh = false
        companiesAdapter.upsertOne(state, action.payload)
      })
      .addCase(fetchCompanyById.rejected, (state, action) => {
        state.loadingCompanyStatus = "rejected"
        state.loadingCompanyError = action.payload.error
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
        state.creatingError = action.payload.error
      })

      .addCase(deleteCompanyById.pending, (state, action) => {
        state.deletingError = null
      })
      .addCase(deleteCompanyById.fulfilled, (state, action) => {
        companiesAdapter.removeOne(state, action.payload)
      })
      .addCase(deleteCompanyById.rejected, (state, action) => {
        state.deletingError = action.payload.error
      })

      .addCase(purchaseUnlock.fulfilled, (state, action) => {
        state.needsRefresh = true
      })
      .addCase(refundUnlock.fulfilled, (state, action) => {
        state.needsRefresh = true
      })
  }
})

export default companiesSlice.reducer

export const { addCost, removeCost, setCurrentCompany } = companiesSlice.actions

export const {
  selectAll: selectAllCompanies,
  selectById: selectCompanyById
} = companiesAdapter.getSelectors(state => state.companies)

export const selectCompanyPop = (state, companyId) => state.companies.entities[companyId]?.pop
export const selectCompanyMan = (state, companyId) => state.companies.entities[companyId]?.man
export const selectCompanyMun = (state, companyId) => state.companies.entities[companyId]?.mun
export const selectCompanyFuel = (state, companyId) => state.companies.entities[companyId]?.fuel
export const selectCompanyActiveBattleId = (state, companyId) => state.companies.entities[companyId]?.activeBattleId
export const selectCompanyDoctrineId = (state, companyId) => state.companies.entities[companyId]?.doctrineId
export const selectCompanyName = (state, companyId) => state.companies.entities[companyId]?.name
export const selectCreatingCompanyStatus = (state) => state.companies.creatingStatus
export const selectCurrentCompany = state => state.companies.currentCompany
