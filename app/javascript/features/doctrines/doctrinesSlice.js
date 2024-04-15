import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const doctrinesAdapter = createEntityAdapter()

const initialState = doctrinesAdapter.getInitialState()

export const fetchDoctrines = createAsyncThunk("doctrines/fetchDoctrines", async () => {
  const response = await axios.get("/doctrines")
  return response.data
})

export const fetchDoctrineUnlocksByDoctrineId = createAsyncThunk(
  "doctrineUnlocks/fetchDoctrineUnlocksByDoctrineId",
  async ({ doctrineId, rulesetId }) => {
    const response = await axios.get(`/doctrines/${doctrineId}/unlocks?rulesetId=${rulesetId}`)
    return response.data
  },
  {
    condition: ({ doctrineId }, { getState, extra }) => {
      /** Skip fetching if already fetched */
      const { doctrines } = getState();
      const doctrine = doctrines.entities[doctrineId]
      return !doctrine.hasOwnProperty("unlocks")
    }
  }
)

const buildDoctrineUnlockTree = (doctrineUnlocks) => {
  // Build a dictionary of doctrine unlocks by
  // row first
  // then - tree * branch
  //  1,1 1,2 2,1 2,2 3,1 3,2
  //   1   2   3   4   5   6
  const unlocks = {}
  for (const doctrineUnlock of doctrineUnlocks) {
    const row = unlocks[doctrineUnlock.row] || []
    row.push(doctrineUnlock)
    unlocks[doctrineUnlock.row] = row
  }

  // Sort each row
  for (const row of Object.values(unlocks)) {
    row.sort((a,b) => {
      if (a.tree < b.tree) {
        return -1
      } else if (a.tree > b.tree) {
        return 1
      } else {
        if (a.branch < b.branch) {
          return -1
        } else if (a.branch > b.branch) {
          return 1
        } else {
          return 0
        }
      }
    })
  }

  return unlocks
}

const doctrinesSlice = createSlice({
  name: "doctrines",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchDoctrines.fulfilled, (state, action) => {
        doctrinesAdapter.setAll(state, action.payload)
      })
      .addCase(fetchDoctrineUnlocksByDoctrineId.fulfilled, (state, action) => {
        if (action.payload.length > 0) {
          const doctrineId = action.payload[0].doctrineId
          doctrinesAdapter.upsertOne(state, { id: doctrineId, unlocks: action.payload, unlocksByRow: buildDoctrineUnlockTree(action.payload) })
        }
      })
  }
})

export default doctrinesSlice.reducer

export const {
  selectAll: selectAllDoctrines,
  selectById: selectDoctrineById
} = doctrinesAdapter.getSelectors(state => state.doctrines)

export const selectDoctrinesByFactionId = (state, factionId) =>{
  const docs = _.values(state.doctrines.entities)
  return docs.filter(doctrine => doctrine.factionId === factionId)
}

export const selectDoctrineUnlockRowsByDoctrineId = (state, doctrineId) => state.doctrines.entities[doctrineId].unlocksByRow


