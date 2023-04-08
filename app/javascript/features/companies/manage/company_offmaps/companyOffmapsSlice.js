import { createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import { fetchCompanySquads, upsertSquads } from "../units/squadsSlice";

const companyOffmapsAdapter = createEntityAdapter()

const initialState = companyOffmapsAdapter.getInitialState({
  newCompanyOffmaps: {},
  isChanged: false,
  isSaving: false,
  notifySnackbar: false,
  errorMessage: null
})

const companyOffmapsSlice = createSlice({
  name: "companyOffmaps",
  initialState,
  reducers: {
    addNewCompanyOffmap(state, action) {
      const { newCompanyOffmap } = action.payload
      const availableOffmapId = newCompanyOffmap.availableOffmapId
      if (availableOffmapId in state.newCompanyOffmaps) {
        state.newCompanyOffmaps[availableOffmapId].push(newCompanyOffmap)
      } else {
        state.newCompanyOffmaps[availableOffmapId] = [newCompanyOffmap]
      }
    },
    removeNewCompanyOffmap(state, action) {
      const { availableOffmapId } = action.payload
      if (availableOffmapId in state.newCompanyOffmaps) {
        state.newCompanyOffmaps[availableOffmapId] = _.dropRight(state.newCompanyOffmaps[availableOffmapId], 1)
      }
    },
    removeExistingCompanyOffmap(state, action) {
      const { id } = action.payload
      companyOffmapsAdapter.removeOne(state, id)
    }
  },
  extraReducers(builder) {
    builder
      .addCase(fetchCompanySquads.fulfilled, (state, action) => {
        companyOffmapsAdapter.setAll(state, action.payload.companyOffmaps)
        state.newCompanyOffmaps = {}
      })
      .addCase(upsertSquads.fulfilled, (state, action) => {
        companyOffmapsAdapter.setAll(state, action.payload.companyOffmaps)
        state.newCompanyOffmaps = {}
      })
  }
})

export default companyOffmapsSlice.reducer

export const { addNewCompanyOffmap, removeNewCompanyOffmap, removeExistingCompanyOffmap } = companyOffmapsSlice.actions

export const {
  selectAll: selectAllCompanyOffmaps,
  selectById: selectCompanyOffmapById,
  selectIds: selectCompanyOffmapIds
} = companyOffmapsAdapter.getSelectors(state => state.companyOffmaps)

export const selectNewCompanyOffmaps = state => state.companyOffmaps.newCompanyOffmaps

export const selectMergedCompanyOffmaps = state => {
  return _.values(state.companyOffmaps.entities).concat(_.values(state.companyOffmaps.newCompanyOffmaps).flat())
}