import React from 'react'
import { makeStyles } from "@mui/styles";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { selectDoctrineById } from "../../doctrines/doctrinesSlice";
import { deleteSnapshotCompanyById, setCurrentCompany } from "../snapshotCompaniesSlice";
import { Box, Button, Card, CardActionArea, CardActions, CardContent, Grid, Typography } from "@mui/material";
import { doctrineImgMapping } from "../../../constants/doctrines";
import DeleteOutlineIcon from "@mui/icons-material/DeleteOutline";

const useStyles = makeStyles(() => ({
  optionImage: {
    height: '80px',
    width: '160px'
  },
  cardContent: {
    paddingTop: 0,
    paddingBottom: 0
  },
  deleteIcon: {
    cursor: 'pointer'
  }
}))

export const SnapshotCompanySummary = ({company}) => {
  const dispatch = useDispatch()
  const classes = useStyles()
  const navigate = useNavigate()

  const doctrine = useSelector(state => selectDoctrineById(state, company.doctrineId))

  const deleteCompany = () => {
    dispatch(deleteSnapshotCompanyById({companyId: company.id}))
  }

  const viewLink = `/companies/snapshots/${company.uuid}`

  const viewCompany = () => {
    dispatch(setCurrentCompany(company))
    navigate(viewLink)
  }

  if (!doctrine) {
    return null
  }

  return (
    <Box>
      <Card>
        <CardActionArea onClick={viewCompany} sx={{flexGrow: 1}}>
          <Box sx={{ display: "flex", justifyContent: 'center' }} pt={1} pb={1}>
            <img src={doctrineImgMapping[doctrine.name]} alt={doctrine.displayName}
                 className={classes.optionImage}/>
          </Box>
          <CardContent className={classes.cardContent}>
            <Typography variant="h6">{company.name}</Typography>
          </CardContent>
        </CardActionArea>
        <CardActions>
          <Grid container>
            <Grid item xs={11}>
              <Button variant="contained" onClick={viewCompany} color="secondary">View</Button>
            </Grid>
            <Grid item xs={1}>
              <DeleteOutlineIcon onClick={deleteCompany} className={classes.deleteIcon} color="error"/>
            </Grid>
          </Grid>
        </CardActions>
      </Card>
    </Box>
  )
}
