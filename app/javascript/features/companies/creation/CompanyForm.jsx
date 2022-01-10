import React, { useEffect, useState } from 'react'
import { Box, Button, Card, Grid, Radio, RadioGroup, TextField, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { Controller, useForm } from "react-hook-form";
import * as yup from "yup"
import { yupResolver } from "@hookform/resolvers/yup";

import airborne from '../../../../assets/images/doctrine_banners/airborne.png'
import armor from '../../../../assets/images/doctrine_banners/armor.png'
import canadians from '../../../../assets/images/doctrine_banners/canadians.png'
import blitz from '../../../../assets/images/doctrine_banners/blitz.png'
import commandos from '../../../../assets/images/doctrine_banners/commandos.png'
import defensive from '../../../../assets/images/doctrine_banners/defensive.png'
import engineers from '../../../../assets/images/doctrine_banners/engineers.png'
import infantry from '../../../../assets/images/doctrine_banners/infantry.png'
import luftwaffe from '../../../../assets/images/doctrine_banners/luftwaffe.png'
import scorched_earth from '../../../../assets/images/doctrine_banners/scorched_earth.png'
import tank_hunters from '../../../../assets/images/doctrine_banners/tank_hunters.png'
import terror from '../../../../assets/images/doctrine_banners/terror.png'
import { ALLIED_SIDE, AXIS_SIDE } from "../../../constants/doctrines";
import { ErrorTypography } from "../../../components/ErrorTypography";

const useStyles = makeStyles(theme => ({
  textInput: {
    '& .MuiOutlinedInput-input': {
      padding: "10px 5px"
    }
  },
  optionImage: {
    height: '80px'
  }
}))

const schema = yup.object().shape({
  name: yup.string().required("Company name is required"),
  doctrine: yup.string().required("Doctrine is required")
})

export const CompanyForm = ({ side, back, company, single = false, companyCallback }) => {
  // Depending on whether the side is axis or allied, show the corresponding list of doctrine options as radio buttons
  // And expose company name field
  const [selectedDoctrine, setSelectedDoctrine] = useState("")

  const classes = useStyles()

  const { reset, handleSubmit, setValue, control, formState: { errors } } = useForm({
    resolver: yupResolver(schema),
  });

  useEffect(() => {
    reset()
    setValue('name', company.name)
    setValue('doctrine', company.doctrine)
    setSelectedDoctrine(company.doctrine)
  }, [company])

  const onSubmit = data => {
    companyCallback(data)
  }

  const controlProps = (item, image) => ({
    checked: selectedDoctrine === item,
    onChange: (e) => setSelectedDoctrine(e.target.value),
    value: item,
    name: "doctrine",
    checkedIcon: <img src={image} alt={item} className={classes.optionImage} />,
    icon: <img src={image} alt={item} style={selectedDoctrine === "" ? {} : { opacity: 0.4 }}
               className={classes.optionImage} />
  })

  let doctrineContent
  let sideTitle
  if (side === ALLIED_SIDE) {
    sideTitle = "Allied"
    doctrineContent = (
      <>
        <Box>
          <Radio {...controlProps("armor", armor)}
          />
          <Radio {...controlProps("infantry", infantry)}
          />
          <Radio {...controlProps("airborne", airborne)}
          />
        </Box>
        <Box>
          <Radio {...controlProps("canadians", canadians)}
          />
          <Radio {...controlProps("commandos", commandos)}
          />
          <Radio {...controlProps("engineers", engineers)}
          />
        </Box>
      </>
    )
  } else if (side === AXIS_SIDE) {
    sideTitle = "Axis"
    doctrineContent = (
      <>
        <Box>
          <Radio {...controlProps("defensive", defensive)}
          />
          <Radio {...controlProps("blitz", blitz)}
          />
          <Radio {...controlProps("terror", terror)}
          />
        </Box>
        <Box>
          <Radio {...controlProps("scorched_earth", scorched_earth)}
          />
          <Radio {...controlProps("luftwaffe", luftwaffe)}
          />
          <Radio {...controlProps("tank_hunters", tank_hunters)}
          />
        </Box>
      </>
    )
  } else {
    doctrineContent = <Typography>Invalid side</Typography>
  }

  let backButton
  if (side === AXIS_SIDE && !single) {
    backButton = (
      <>
        <Grid item xs={2}>
          <Button variant="outlined" color="secondary" size="small" sx={{ marginRight: "10px" }}
                  onClick={back}>Back</Button>
        </Grid>
        <Grid item xs={8} />
      </>
    )
  } else {
    backButton = (
      <Grid item xs={10} />
    )
  }

  // Radios have a 9px padding left, decided to add to other elements so they are aligned vertically
  return (
    <Box m={5} sx={{ maxWidth: '600px' }} justifyContent="center">
      <Card elevation={3} sx={{padding: '16px'}}>
        <Typography variant={"h5"} pl={"9px"} gutterBottom>New {sideTitle} Company</Typography>
        <form onSubmit={handleSubmit(onSubmit)}>
          <Box pl={"9px"} pb={2}>
            <Controller
              name="name" control={control} rules={{ required: true }} defaultValue=""
              render={({ field }) => (
                <TextField
                  variant="standard"
                  label="Company Name"
                  color="secondary"
                  error={Boolean(errors.name)}
                  helperText={errors.name?.message}
                  className={classes.textInput} {...field}
                />)}
            />
          </Box>
          <Box pt={2} pb={2}>
            <Typography pl={"9px"}>Select Doctrine</Typography>
            <Controller
              name="doctrine" control={control} rules={{ required: true }} defaultValue={company.doctrine}
              render={({ field }) => (
                <RadioGroup {...field}>
                  {doctrineContent}
                </RadioGroup>
              )}
            />
            <ErrorTypography pl={"9px"}>{errors.doctrine?.message}</ErrorTypography>
          </Box>
          <Grid container pt={4}>
            {backButton}
            <Grid item xs={2} container justifyContent="flex-end">
              <Button variant="contained" type="submit" color="secondary" size="small"
                      sx={{ marginRight: '9px' }}>{single ? "Save" : "Next"}</Button>
            </Grid>
          </Grid>
        </form>
      </Card>
    </Box>
  )
}
