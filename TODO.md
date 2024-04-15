### Data model
1. Should CallinModifier, Restriction also be associated with Ruleset to allow for modifications across rulesets?

### SquadBuilder
1. Only open the transport drop target when dragging units/squads

### Upgrades
1. Squad `pop` and `popWithTransported` isn't consistent. CompanyGridDropTarget is calculating platoon pop with `popWithTransported` but that isn't updated for squad upgrade pop
2. Show enabled upgrades in the Unlocks card
3. Enable upgrade by unit and minimum vet
4. Should Falls have only 1 of fg42, schreck, at rifles, g43? Can fg42 and g43 be unitwide? seems to be priority issues where fg42 over schreck

### Redux
1. Fix missing rejectWithValue. See fetchCompanyBonuses for example

### BattlePlayer
1. Pass `side` back for the BattlePlayer to create, to avoid relying on `company.faction.side` which may not be correct (ie, mixed teams)
2. Add `side` to `HistoricalBattlePlayer`
3. Use `HistoricalBattlePlayer.side` for war stats calculation

### Player
1. Create a separate RulesetPlayer record to encapsulate ruleset specific data like vps current/earned in that ruleset

### Unlocks
1. Tooltip for enabled units
2. EnabledUpgrades

### Performance
1. doctrine_unlock.rb associations for Grape entities are sequential

### UI
1. Discord invite icon
2. Leaderboards for company stats
3. Show VPs in player battle cards
4. Mobile MVP
5. Confirmation before deleting company
6. Confirmation before deleting squad
7. Companies display to use error snackbar instead of errorTypography

### Enhancements
1. Copy paste squad/upgrade combo
2. Holding area for squad cards outside of tabs
3. User preferences model (ie, saving compact status)

### TODO
1. War Stats page
2. Company Snapshot descriptions & tab notes
3. War reset admin page
4. Clear company related slices when component closes for CompanyManager, SnapshotCompanyView
5. Add authorization for company/player specific endpoints

### Reset Ratings
1. `Ratings::HistoricalPlayerRatingsService.create_or_update` to reseed HPR with updated elo output csv
2. 