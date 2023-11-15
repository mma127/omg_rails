import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"

const battlesAdapter = createEntityAdapter()

const initialState = battlesAdapter.getInitialState({
  loadingBattlesError: null,
  creatingBattleStatus: "idle",
  creatingBattleError: null,
  updatingBattleStatus: "idle",
  updatingBattleError: null,
  isPending: false,
  errorMessage: null
})

/**
 * Fetch all active battles
 * TODO Ruleset
 */
export const fetchActiveBattles = createAsyncThunk(
  "lobby/fetchActiveBattles",
  async (_, {__, rejectWithValue}) => {
    try {
      const response = await axios.get("/battles")
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

export const createBattle = createAsyncThunk(
  "lobby/createBattle",
  async ({ name, size, rulesetId, initialCompanyId }, {_, rejectWithValue}) => {
    try {
      const response = await axios.post("/battles/player/create_match", { name, size, rulesetId, initialCompanyId })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

export const joinBattle = createAsyncThunk(
  "lobby/joinBattle",
  async ({ battleId, companyId }, {_, rejectWithValue}) => {
    try {
      const response = await axios.post("/battles/player/join_match", { battleId, companyId })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

export const leaveBattle = createAsyncThunk(
  "lobby/leaveBattle",
  async ({ battleId, playerId }, {_, rejectWithValue}) => {
    try {
      const response = await axios.post("/battles/player/leave_match", { battleId, playerId })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

export const readyPlayer = createAsyncThunk(
  "lobby/readyPlayer",
  async ({ battleId, playerId }, {_, rejectWithValue}) => {
    try {
      const response = await axios.post("/battles/player/ready", { battleId, playerId })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

export const unreadyPlayer = createAsyncThunk(
  "lobby/unreadyPlayer",
  async ({ battleId, playerId }, {_, rejectWithValue}) => {
    try {
      const response = await axios.post("/battles/player/unready", { battleId, playerId })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

export const abandonBattle = createAsyncThunk(
  "lobby/abandonBattle",
  async ({ battleId, playerId }, {_, rejectWithValue}) => {
    try {
      const response = await axios.post("/battles/player/abandon", { battleId, playerId })
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

export const downloadBattlefile = createAsyncThunk(
  "lobby/downloadBattlefile",
  async ({ battleId }, {_, rejectWithValue}) => {
    try {
      const response = await axios.post(`/battles/${battleId}/battlefiles/zip`)
      return response.data
    } catch (err) {
      return rejectWithValue(err.response.data)
    }
  }
)

const lobbySlice = createSlice({
  name: "lobby",
  initialState,
  reducers: {
    addNewBattle(state, action) {
      const { battle } = action.payload
      battlesAdapter.setOne(state, battle)
    },
    updateBattle(state, action) {
      const { battle } = action.payload
      battlesAdapter.setOne(state, battle)
    },
    removeBattle(state, action) {
      const {battle} = action.payload
      battlesAdapter.removeOne(state, battle.id)
    }
  },
  extraReducers(builder) {
    builder
      .addCase(fetchActiveBattles.pending, (state, action) => {
        state.errorMessage = null
      })
      .addCase(fetchActiveBattles.fulfilled, (state, action) => {
        battlesAdapter.setAll(state, action.payload)
      })
      .addCase(fetchActiveBattles.rejected, (state, action) => {
        state.errorMessage = action.payload.error
      })

      .addCase(createBattle.pending, (state, action) => {
        state.creatingBattleStatus = "pending"
        state.isPending = true
        state.errorMessage = null
      })
      .addCase(createBattle.fulfilled, (state, action) => {
        state.creatingBattleStatus = "fulfilled"
        state.isPending = false
      })
      .addCase(createBattle.rejected, (state, action) => {
        state.creatingBattleStatus = "rejected"
        state.isPending = false
        state.errorMessage = action.payload.error
      })

      .addCase(joinBattle.pending, (state, action) => {
        state.updatingBattleStatus = "pending"
        state.isPending = true
        state.errorMessage = null
      })
      .addCase(joinBattle.fulfilled, (state, action) => {
        state.updatingBattleStatus = "fulfilled"
        state.isPending = false
      })
      .addCase(joinBattle.rejected, (state, action) => {
        state.updatingBattleStatus = "rejected"
        state.isPending = false
        state.errorMessage = action.payload.error
      })

      .addCase(leaveBattle.pending, (state, action) => {
        state.errorMessage = null
        state.isPending = true
      })
      .addCase(leaveBattle.fulfilled, (state, action) => {
        state.isPending = false
      })
      .addCase(leaveBattle.rejected, (state, action) => {
        state.errorMessage = action.payload.error
        state.isPending = false
      })

      .addCase(readyPlayer.pending, (state, action) => {
        state.errorMessage = null
        state.isPending = true
      })
      .addCase(readyPlayer.fulfilled, (state, action) => {
        state.errorMessage = null
        state.isPending = false
      })
      .addCase(readyPlayer.rejected, (state, action) => {
        state.errorMessage = action.payload.error
        state.isPending = false
      })

      .addCase(unreadyPlayer.pending, (state, action) => {
        state.errorMessage = null
        state.isPending = true
      })
      .addCase(unreadyPlayer.fulfilled, (state, action) => {
        state.errorMessage = null
        state.isPending = false
      })
      .addCase(unreadyPlayer.rejected, (state, action) => {
        state.errorMessage = action.payload.error
        state.isPending = false
      })

      .addCase(abandonBattle.pending, (state, action) => {
        state.errorMessage = null
        state.isPending = true
      })
      .addCase(abandonBattle.fulfilled, (state, action) => {
        state.errorMessage = null
        state.isPending = false
      })
      .addCase(abandonBattle.rejected, (state, action) => {
        state.errorMessage = action.payload.error
        state.isPending = false
      })
  }
})

export default lobbySlice.reducer

export const { addNewBattle, updateBattle, removeBattle } = lobbySlice.actions

export const {
  selectAll: selectAllActiveBattles,
  selectById: selectBattleById
} = battlesAdapter.getSelectors(state => state.lobby)

export const selectIsPending = state => state.lobby.isPending
