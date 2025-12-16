const axios = require("axios").default;
const qs = require("qs");

async function _getAIResponseCall(context, ffVariables) {
  if (!context.auth) {
    return _unauthenticatedResponse;
  }
  var message = ffVariables["message"];

  var url = `https://aihelper-qwbkarwska-uc.a.run.app`;
  var headers = {};
  var params = {};
  var ffApiRequestBody = `
{
  "prompt": "${escapeStringForJson(message)}"
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}
async function _plaidExchangeTokenCall(context, ffVariables) {
  if (!context.auth) {
    return _unauthenticatedResponse;
  }
  var publicToken = ffVariables["publicToken"];

  var url = `https://sandbox.plaid.com/item/public_token/exchange`;
  var headers = { Key: `Content-Type Value: application/json` };
  var params = {};
  var ffApiRequestBody = `
{
  "client_id": "68f657d97c634d00204cc9ef",
  "secret": "8d46e5bf10e07514de59348254e316",
  "public_token": "${escapeStringForJson(publicToken)}"
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}
async function _tempCall(context, ffVariables) {
  var url = `https://sandbox.plaid.com/sandbox/public_token/create`;
  var headers = {};
  var params = {};
  var ffApiRequestBody = `
{
  "client_id": "68f657d97c634d00204cc9ef",
  "secret": "8d46e5bf10e07514de59348254e316",
  "institution_id": "ins_109508",
  "initial_products": ["transactions"]
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}
async function _plaidGetTransactionsCall(context, ffVariables) {
  if (!context.auth) {
    return _unauthenticatedResponse;
  }
  var accessToken = ffVariables["accessToken"];

  var url = `https://sandbox.plaid.com/transactions/sync`;
  var headers = { Key: `Content-Type Value: application/json` };
  var params = {};
  var ffApiRequestBody = `
{
  "client_id": "68f657d97c634d00204cc9ef",
  "secret": "8d46e5bf10e07514de59348254e316",
  "access_token": "${escapeStringForJson(accessToken)}"
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}
async function _plaidCreateLinkTokenCall(context, ffVariables) {
  if (!context.auth) {
    return _unauthenticatedResponse;
  }
  var userId = ffVariables["userId"];

  var url = `https://sandbox.plaid.com/link/token/create`;
  var headers = { Key: `Content-Type Value: application/json` };
  var params = {};
  var ffApiRequestBody = `
{
  "client_id": "68f657d97c634d00204cc9ef",
  "secret": "8d46e5bf10e07514de59348254e316",
  "user": {
    "client_user_id": "user_good"
  },
  "client_name": "Strive",
  "products": [
    "transactions"
  ],
  "country_codes": [
    "US"
  ],
  "language": "en"
}`;

  return makeApiRequest({
    method: "post",
    url,
    headers,
    params,
    body: createBody({
      headers,
      params,
      body: ffApiRequestBody,
      bodyType: "JSON",
    }),
    returnBody: true,
    isStreamingApi: false,
  });
}

/// Helper functions to route to the appropriate API Call.

async function makeApiCall(context, data) {
  var callName = data["callName"] || "";
  var variables = data["variables"] || {};

  const callMap = {
    GetAIResponseCall: _getAIResponseCall,
    PlaidExchangeTokenCall: _plaidExchangeTokenCall,
    TempCall: _tempCall,
    PlaidGetTransactionsCall: _plaidGetTransactionsCall,
    PlaidCreateLinkTokenCall: _plaidCreateLinkTokenCall,
  };

  if (!(callName in callMap)) {
    return {
      statusCode: 400,
      error: `API Call "${callName}" not defined as private API.`,
    };
  }

  var apiCall = callMap[callName];
  var response = await apiCall(context, variables);
  return response;
}

async function makeApiRequest({
  method,
  url,
  headers,
  params,
  body,
  returnBody,
  isStreamingApi,
}) {
  return axios
    .request({
      method: method,
      url: url,
      headers: headers,
      params: params,
      responseType: isStreamingApi ? "stream" : "json",
      ...(body && { data: body }),
    })
    .then((response) => {
      return {
        statusCode: response.status,
        headers: response.headers,
        ...(returnBody && { body: response.data }),
        isStreamingApi: isStreamingApi,
      };
    })
    .catch(function (error) {
      return {
        statusCode: error.response.status,
        headers: error.response.headers,
        ...(returnBody && { body: error.response.data }),
        error: error.message,
      };
    });
}

const _unauthenticatedResponse = {
  statusCode: 401,
  headers: {},
  error: "API call requires authentication",
};

function createBody({ headers, params, body, bodyType }) {
  switch (bodyType) {
    case "JSON":
      headers["Content-Type"] = "application/json";
      return body;
    case "TEXT":
      headers["Content-Type"] = "text/plain";
      return body;
    case "X_WWW_FORM_URL_ENCODED":
      headers["Content-Type"] = "application/x-www-form-urlencoded";
      return qs.stringify(params);
  }
}
function escapeStringForJson(val) {
  if (typeof val !== "string") {
    return val;
  }
  return val
    .replace(/[\\]/g, "\\\\")
    .replace(/["]/g, '\\"')
    .replace(/[\n]/g, "\\n")
    .replace(/[\t]/g, "\\t");
}

module.exports = { makeApiCall };
