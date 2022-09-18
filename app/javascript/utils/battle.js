export const isPlayerInBattle = (playerId, battlePlayers) => {
  return Boolean(battlePlayers.find(bp => bp.playerId === playerId))
}
