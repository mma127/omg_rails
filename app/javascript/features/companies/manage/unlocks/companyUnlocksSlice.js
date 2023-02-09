import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"
import { fetchCompanyById } from "../../companiesSlice";
import { fetchDoctrineUnlocksByDoctrineId } from "../../../doctrines/doctrinesSlice";

const companyUnlocksAdapter = createEntityAdapter()

const initialState = companyUnlocksAdapter.getInitialState({
  activeCompanyId: null,
  isChanged: false,
  isSaving: false,
  needFetch: false,
  notifySnackbar: false,
  errorMessage: null
})

export const purchaseUnlock = createAsyncThunk(
  "companyUnlocks/purchaseUnlock",
  async ({ doctrineUnlockId }, { getState, rejectWithValue }) => {
    try {
      const companyId = selectActiveCompanyId(getState())
      const response = await axios.post(`/companies/${companyId}/unlocks`, { doctrineUnlockId })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

const companyUnlocksSlice = createSlice({
  name: "companyUnlocks",
  initialState,
  reducers: {
    resetCompanyUnlockState: () => initialState
  },
  extraReducers(builder) {
    builder
      .addCase(fetchCompanyById.fulfilled, (state, action) => {
        companyUnlocksAdapter.setAll(state, action.payload.unlocks)
        state.activeCompanyId = action.payload.id
      })
      .addCase(purchaseUnlock.pending, (state, action) => {
        state.errorMessage = null
        state.notifySnackbar = false
        state.isSaving = true
      })
      .addCase(purchaseUnlock.fulfilled, (state, action) => {
        companyUnlocksAdapter.addOne(state, action.payload)
        state.isChanged = true
        state.notifySnackbar = true
        state.isSaving = false
      })
      .addCase(purchaseUnlock.rejected, (state, action) => {
        state.errorMessage = action.payload.error
        state.notifySnackbar = true
        state.isSaving = false
      })
  }
})

export default companyUnlocksSlice.reducer

export const { resetCompanyUnlockState } = companyUnlocksSlice.actions

export const {
  selectAll: selectAllCompanyUnlocks,
  selectById: selectCompanyUnlockById,
  selectIds: selectCompanyUnlockIds
} = companyUnlocksAdapter.getSelectors(state => state.companyUnlocks)

export const selectIsCompanyUnlocksChanged = state => {
  return state.companyUnlocks.isChanged
}

export const selectCompanyUnlocksByDoctrineUnlockId = state => {
  return Object.values(state.companyUnlocks.entities).reduce((o, cu) => ({...o, [cu.doctrineUnlockId]: cu}), {})
}

export const selectActiveCompanyId = state => state.companyUnlocks.activeCompanyId