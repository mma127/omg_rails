import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios";
import { fetchSnapshotCompanySquads } from "./manage/units/squadsSlice";

const snapshotCompaniesAdapter = createEntityAdapter()

const initialState = snapshotCompaniesAdapter.getInitialState({
  loadingCompaniesError: null,
  loadingCompanyStatus: "idle",
  loadingCompanyError: null,
  creatingStatus: "idle",
  creatingError: null,
  currentCompany: null,
  deletingError: null,
  notifySnackbar: false

})

export const loadSnapshotCompany = ({ uuid }) => async (dispatch, getState) => {
  await dispatch(fetchSnapshotCompanyByUuid({ companyUuid: uuid }))
  dispatch(fetchSnapshotCompanySquads({ uuid: uuid }))
}

/**
 * Fetch light version of the player's snapshot companies
 */
export const fetchPlayerSnapshotCompanies = createAsyncThunk(
  "snapshotCompanies/fetchPlayerSnapshotCompanies",
  async (_, { rejectWithValue }) => {
    try {
      const response = await axios.get("/snapshot_companies/owned")
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  })

/**
 * Fetch a specific snapshot company to populate detailed company view
 */
export const fetchSnapshotCompanyByUuid = createAsyncThunk(
  "snapshotCompanies/fetchSnapshotCompanyByUuid",
  async ({ companyUuid }, { rejectWithValue }) => {
    try {
      const response = await axios.get(`/snapshot_companies/${companyUuid}`)
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  })

export const createSnapshotCompany = createAsyncThunk(
  "snapshotCompanies/createSnapshotCompany",
  async ({ name, sourceCompanyId }, { rejectWithValue }) => {
    try {
      const response = await axios.post("/snapshot_companies/owned", { name, sourceCompanyId })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

export const deleteSnapshotCompanyById = createAsyncThunk(
  "snapshotCompanies/deleteSnapshotCompany",
  async ({ companyId }, { rejectWithValue }) => {
    try {
      const response = await axios.delete(`/snapshot_companies/owned/${companyId}`)
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  })

const snapshotCompaniesSlice = createSlice({
  name: "snapshotCompanies",
  initialState,
  reducers: {
    setCurrentCompany(state, action) {
      state.currentCompany = action.payload
    },
    resetSnapshotState: () => initialState,
    clearNotifySnackbarSnapshot(state) {
      state.notifySnackbar = false
      state.creatingStatus = "idle"
      state.creatingError = null
    },
    showSnapshotSnackbar: (state, action) => {
      state.notifySnackbar = true
    }
  },
  extraReducers(builder) {
    builder
      .addCase(fetchPlayerSnapshotCompanies.fulfilled, (state, action) => {
        snapshotCompaniesAdapter.setAll(state, action.payload)
      })
      .addCase(fetchPlayerSnapshotCompanies.rejected, (state, action) => {
        if (!_.isNil(action.payload)) {
          state.loadingCompaniesError = action.payload.error
        }
      })

      .addCase(fetchSnapshotCompanyByUuid.pending, (state) => {
        state.loadingCompanyStatus = "pending"
        state.loadingCompanyError = null
      })
      .addCase(fetchSnapshotCompanyByUuid.fulfilled, (state, action) => {
        state.loadingCompanyStatus = "fulfilled"
        if (action.payload) {
          state.currentCompany = action.payload
        }
      })
      .addCase(fetchSnapshotCompanyByUuid.rejected, (state, action) => {
        state.loadingCompanyStatus = "rejected"
        state.loadingCompanyError = action.payload.error
      })

      .addCase(createSnapshotCompany.pending, (state) => {
        state.creatingStatus = "pending"
        state.creatingError = null
        state.notifySnackbar = false
      })
      .addCase(createSnapshotCompany.fulfilled, (state, action) => {
        state.creatingStatus = "fulfilled"
        snapshotCompaniesAdapter.setOne(state, action.payload)
        state.notifySnackbar = true
      })
      .addCase(createSnapshotCompany.rejected, (state, action) => {
        state.creatingStatus = "rejected"
        state.creatingError = action.payload.error
        state.notifySnackbar = true
      })

      .addCase(deleteSnapshotCompanyById.pending, (state, action) => {
        state.deletingError = null
      })
      .addCase(deleteSnapshotCompanyById.fulfilled, (state, action) => {
        snapshotCompaniesAdapter.removeOne(state, action.payload.id)
        state.notifySnackbar = true
      })
      .addCase(deleteSnapshotCompanyById.rejected, (state, action) => {
        state.deletingError = action.payload.error
      })
  }
})

export default snapshotCompaniesSlice.reducer
export const { setCurrentCompany, resetSnapshotState, clearNotifySnackbarSnapshot, showSnapshotSnackbar } = snapshotCompaniesSlice.actions

export const {
  selectAll: selectAllSnapshotCompanies,
  selectById: selectSnapshotCompanyById
} = snapshotCompaniesAdapter.getSelectors(state => state.snapshotCompanies)

export const selectCurrentSnapshotCompany = state => state.snapshotCompanies.currentCompany
