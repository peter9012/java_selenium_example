package com.rf.core.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import java.util.TimeZone;


/**
 * Utility class for common functions.
 * 
 * @author GSPANN
 * 
 */
public class CommonUtils {


	public static FileOutputStream getFileOutputStream(final String fileName) throws IOException {
		FileOutputStream fos = new FileOutputStream(fileName);
		return fos;
	}

	public static InputStream loadInputStream(final String classpathLocation, final String fileSystemLocation)
			throws IOException {
		InputStream in = null;

		in = CommonUtils.class.getResourceAsStream(classpathLocation);
		if (in == null) {
			in = new FileInputStream(fileSystemLocation);
		}
		return in;
	}

	public static void sleep(long millis) {
		try {
			Thread.sleep(millis);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Returns test dat file path attached at test class
	 * 
	 * @return the path string
	 */
	public static String getTestDataFilePath(final String className) {
		String fileSep = File.separator;
		return System.getProperty("user.dir") + fileSep + "test"+fileSep+"resources"+fileSep+"testdata"+fileSep + className + ".xlsx";
	}


	/**
	 * Returns Integer value of Amount
	 * 
	 * @param value
	 * @return - Integer Value
	 */
	public static int getIntVal(String value) {
		String stringVal = value;
		if (value.contains(".")) {
			String[] valArray = stringVal.split("[.]");
			stringVal = valArray[0];
		}
		if (value.contains(",")) {
			stringVal = stringVal.replace(",", "");
		}
		return Integer.parseInt(stringVal);
	}

	/**
	 * Generates random integer from a range
	 * 
	 * @param min
	 * @param max
	 * @return - random integer
	 */
	public static int getRandomNum(int min, int max) {
		return new Random().nextInt((max - min) + 1) + min;
	} 

	public static String getRandomWord(int length) {
		String r = "";
		for(int i = 0; i < length; i++) {
			r += (char)(Math.random() * 26 + 97);
		}
		return r;
	}

	public static String getCurrentDate(String dayFormat, TimeZone timeZone) {
		Date date = new Date();
		/* Specifying the format */
		DateFormat requiredFormat = new SimpleDateFormat(dayFormat);
		/* Setting the Timezone */
		requiredFormat.setTimeZone(timeZone);
		/* Picking the day value in the required Format */
		String strCurrentDay = requiredFormat.format(date).toUpperCase();
		return strCurrentDay;
	}

	public static String convertDBDateFormatToUIFormat(String DBDate){
		String UIMonth=null;
		String[] splittedDate = DBDate.split(" ");
		String date = (splittedDate[0].split("-")[2].charAt(0))=='0'?splittedDate[0].split("-")[2].split("0")[1]:splittedDate[0].split("-")[2];
		String month = (splittedDate[0].split("-")[1].charAt(0))=='0'?splittedDate[0].split("-")[1].split("0")[1]:splittedDate[0].split("-")[1];		
		String year = splittedDate[0].split("-")[0];		
		switch (Integer.parseInt(month)) {		
		case 1:
			UIMonth="January";
			break;
		case 2:
			UIMonth="February";
			break;
		case 3:
			UIMonth="March";
			break;
		case 4:
			UIMonth="April";
			break;
		case 5:
			UIMonth="May";
			break;
		case 6:
			UIMonth="June";
			break;
		case 7:
			UIMonth="July";
			break;
		case 8:
			UIMonth="August";
			break;
		case 9:
			UIMonth="September";
			break;
		case 10:
			UIMonth="October";
			break;
		case 11:
			UIMonth="November";
			break;
		case 12:
			UIMonth="December";
			break;		
		}

		return UIMonth+" "+date+", "+year;
	}


}
