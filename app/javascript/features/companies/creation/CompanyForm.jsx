import React, { useEffect, useState } from 'react'
import {
  Box, Button,
  FormControl,
  FormControlLabel,
  FormHelperText,
  InputLabel,
  Radio,
  RadioGroup, TextField,
  Typography
} from "@mui/material";
import { makeStyles } from "@mui/styles";
import { useForm, Controller } from "react-hook-form";
import * as yup from "yup"
import { yupResolver } from "@hookform/resolvers/yup";

import airborne from '../../../../assets/images/doctrine_banners/airborne.png'
import armor from '../../../../assets/images/doctrine_banners/armor.png'
import artillery from '../../../../assets/images/doctrine_banners/artillery.png'
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

const useStyles = makeStyles(theme => ({
  textInput: {
    '& .MuiOutlinedInput-input': {
      padding: "10px 5px"
    }
  },
  optionImage: {
    height: '120px',
    width: '240px'
  }

}))

const schema = yup.object().shape({
  name: yup.string().required(),
  doctrine: yup.string().required()
})

export const CompanyForm = ({ side, back, company, companyCallback }) => {
  // Depending on whether the side is axis or allies, show the corresponding list of doctrine options as radio buttons
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
          <Radio {...controlProps("artillery", artillery)}
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

  return (
    <Box sx={{ maxWidth: '800px' }} justifyContent="center">
      <form onSubmit={handleSubmit(onSubmit)}>
        <Box>
          <label>Company Name</label>
          <Controller
            name="name" control={control} rules={{ required: true }} defaultValue=""
            render={({ field }) => <TextField className={classes.textInput} {...field} />} />
          <Typography>{errors.name?.message}</Typography>
        </Box>
        <Box>
          <label>Select {sideTitle} Doctrine</label>
          <Controller
            name="doctrine" control={control} rules={{ required: true }} defaultValue={company.doctrine}
            render={({ field }) => (
              <RadioGroup {...field}>
                {doctrineContent}
              </RadioGroup>
            )}
          />
          <Typography>{errors.doctrine?.message}</Typography>
        </Box>

        {side === AXIS_SIDE ? <Button variant="contained" onClick={back}>Back</Button> : ''}
        <Button variant="contained" type="submit">Submit</Button>
      </form>
    </Box>
  )
}
