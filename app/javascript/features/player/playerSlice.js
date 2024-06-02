import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import axios from "axios";
import { createBattle, fetchActiveBattles, leaveBattle } from "../lobby/lobbySlice";

const initialState = {
  data: null,
  status: "idle",
  currentBattleId: null
}

export const fetchPlayer = createAsyncThunk("player/fetchPlayer", async () => {
  const response = await axios.get('/player')
  return response.data
})

const playerSlice = createSlice({
  name: "player",
  initialState,
  reducers: {
    setCurrentBattle(state, action) {
      const { battleId } = action.payload
      state.currentBattleId = battleId
    }
  },
  extraReducers(builder) {
    builder
      .addCase(fetchPlayer.pending, (state) => {
        state.status = "pending"
      })
      .addCase(fetchPlayer.fulfilled, (state, action) => {
        state.status = "fulfilled"
        state.data = action.payload
      })
      .addCase(fetchPlayer.rejected, (state) => {
        state.status = "rejected"
        state.data = null
      })

      .addCase(fetchActiveBattles.fulfilled, (state, action) => {
        // TODO this is a bit questionable, might have issues if out of order
        if (action.payload && state.data?.id) {
          const currentBattle = action.payload.find(battle => battle.battlePlayers.find(bp => bp.playerId === state.data.id))
          state.currentBattleId = currentBattle ? currentBattle.id : null
        }
      })

      .addCase(createBattle.fulfilled, (state, action) => {
        state.currentBattleId = action.payload.id
      })

      .addCase(leaveBattle.fulfilled, (state, action) => {
        state.currentBattleId = null
      })
  }
})

export default playerSlice.reducer

export const { setCurrentBattle } = playerSlice.actions

export const selectPlayer = state => state.player.data
export const selectIsAuthed = state => Boolean(state.player.data)
export const selectPlayerCurrentBattleId = state => state.player.currentBattleId
