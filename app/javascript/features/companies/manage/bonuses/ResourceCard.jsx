import React from "react";
import { makeStyles } from "@mui/styles";
import { useDispatch, useSelector } from "react-redux";
import {
  purchaseCompanyResourceBonus,
  refundCompanyResourceBonus,
  selectAvailableRBs,
  selectCompanyBonuses
} from "./companyBonusesSlice";
import {
  Box,
  Button,
  Card,
  CardActions,
  CardContent,
  Grid,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography
} from "@mui/material";
import { FUEL, MAN, MUN, RESOURCE_TO_ICON, RESOURCE_TO_NAME } from "../../../../constants/resources";
import { ResourceIcon } from "../../../resources/ResourceIcon";
import { useParams } from "react-router-dom";
import { selectCompanyActiveBattleId } from "../../companiesSlice";

const getResourceTitle = (resource) => {
  return RESOURCE_TO_NAME[resource]
}

const useStyles = makeStyles(theme => ({
  headerRow: {
    display: "flex",
    justifyContent: "space-between",
    marginBottom: "1rem"
  },
  resourceTextIconContainer: {
    display: "flex",
    alignItems: "center"
  },
  resourceIcon: {
    height: "24px",
    width: "24px"
  },
  resourceIconSmall: {
    height: "16px",
    width: "16px"
  },
  actionContainer: {
    display: "flex",
    alignItems: "center",
    justifyContent: "space-between",
    flexGrow: 1
  },
  actionBtn: {
    lineHeight: '1'
  }
}))

const ResourceQuantity = ({ quantity, isEmpty = false }) => {
  if (isEmpty) {
    return <Typography>-</Typography>
  }
  let color
  if (quantity > 0) {
    color = "success.main"
    quantity = `+${ quantity }`
  } else if (quantity < 0) {
    color = "error"
  }
  return <Typography color={ color }>{ quantity }</Typography>
}

export const ResourceCard = ({ resource, availableRB }) => {
  const dispatch = useDispatch()
  const classes = useStyles()

  const companyBonuses = useSelector(selectCompanyBonuses);

  let params = useParams()
  const companyId = params.companyId
  const activeBattleId = useSelector(state => selectCompanyActiveBattleId(state, companyId))
  const battleLocked = !!activeBattleId

  const maxRB = companyBonuses.maxResourceBonuses
  const rbKey = `${ resource }ResourceBonus`
  const countKey = `${ resource }BonusCount`
  const currentKey = `${ resource }Current`

  const rb = companyBonuses[rbKey]
  const count = companyBonuses[countKey]

  const handleRefundClick = () => {
    dispatch(refundCompanyResourceBonus({ resource }))
  }

  const handlePurchaseClick = () => {
    dispatch(purchaseCompanyResourceBonus({ resource }))
  }

  let refundContent = <Box></Box>
  let purchaseContent

  if (count > 0) {
    refundContent = <Button variant="contained" type="submit" color="secondary" size="small"
                            className={ classes.actionBtn } onClick={ handleRefundClick } disabled={battleLocked}>Refund</Button>
  }

  if (availableRB > 0) {
    purchaseContent = <Button variant="contained" type="submit" color="secondary" size="small"
                              className={ classes.actionBtn } onClick={ handlePurchaseClick } disabled={battleLocked}>Purchase</Button>
  } else {
    purchaseContent = <Button variant="contained" type="submit" color="secondary" size="small"
                              className={ classes.actionBtn } disabled>Purchase</Button>
  }

  let color
  if (count / maxRB > 0.8) {
    color = "secondary.dark"
  } else if (count / maxRB > 0.4) {
    color = "secondary.main"
  } else if (count/maxRB > 0) {
    color = "secondary.light"
  }

  return (
    <Card sx={ { minWidth: "200px" } }>
      <CardContent>
        <Box className={ classes.headerRow }>
          <Box className={ classes.resourceTextIconContainer }>
            <ResourceIcon resource={ resource }/>
            <Typography variant="h5" sx={ { paddingLeft: "0.3rem" } }>{ getResourceTitle(resource) }</Typography>
          </Box>
          <Typography variant="h5" color={ color }>+{ count }</Typography>
        </Box>

        <Box className={ classes.resourceTextIconContainer } paddingBottom={ 2 }>
          <Typography paddingRight={ 0.5 }>Company: { companyBonuses[currentKey] }</Typography>
          <ResourceIcon resource={ resource } small={ true }/>
        </Box>

        <TableContainer>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell></TableCell>
                <TableCell>
                  <ResourceIcon resource={ MAN } small={ true }/>
                </TableCell>
                <TableCell>
                  <ResourceIcon resource={ MUN } small={ true }/>
                </TableCell>
                <TableCell>
                  <ResourceIcon resource={ FUEL } small={ true }/>
                </TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              <TableRow>
                <TableCell>
                  <Typography>Per RB</Typography>
                </TableCell>
                <TableCell>
                  <ResourceQuantity quantity={ rb[MAN] } isEmpty={ false }/>
                </TableCell>
                <TableCell>
                  <ResourceQuantity quantity={ rb[MUN] } isEmpty={ false }/>
                </TableCell>
                <TableCell>
                  <ResourceQuantity quantity={ rb[FUEL] } isEmpty={ false }/>
                </TableCell>
              </TableRow>
              <TableRow>
                <TableCell>
                  <Typography>Current</Typography>
                </TableCell>
                <TableCell>
                  <ResourceQuantity isEmpty={ count === 0 } quantity={ rb[MAN] * count }/>
                </TableCell>
                <TableCell>
                  <ResourceQuantity isEmpty={ count === 0 } quantity={ rb[MUN] * count }/>
                </TableCell>
                <TableCell>
                  <ResourceQuantity isEmpty={ count === 0 } quantity={ rb[FUEL] * count }/>
                </TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </TableContainer>
      </CardContent>
      <CardActions>
        <Box className={ classes.actionContainer }>
          { refundContent }
          { purchaseContent }
        </Box>
      </CardActions>
    </Card>
  )
}
