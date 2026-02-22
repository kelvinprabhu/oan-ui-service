// --- V3 Telemetry Specification Alignment ---

// Declare V3 Telemetry methods required for this implementation
// Note: Implementations for all methods are assumed to exist in the global Telemetry object.
declare let Telemetry: any;
declare let AuthTokenGenerate: any;

// Function to get the current host URL
const getHostUrl = (): string => {
  if (typeof window !== 'undefined') {
    return window.location.origin;
  }
  return 'unknown-host';
};

export const startTelemetry = (sessionId: string, userDetailsObj: { preferred_username: string; email: string }) => {
  // Use environment variables or fallbacks for security
  const key = import.meta.env.VITE_TELEMETRY_KEY || "gyte5565fdbgbngfnhgmnhmjgm,jm,";
  const secret = import.meta.env.VITE_TELEMETRY_SECRET || "gnjhgjugkk";

  // Use environment variables or fallbacks
  const telemetryHost = import.meta.env.VITE_TELEMETRY_HOST || "http://localhost:3000";
  const telemetryChannel = import.meta.env.VITE_TELEMETRY_CHANNEL || "MahaVistaar";
  const productId = import.meta.env.VITE_TELEMETRY_PRODUCT_ID || "MahaVistaar";
  const productVersion = import.meta.env.VITE_TELEMETRY_PRODUCT_VERSION || "v0.1";
  const productPid = import.meta.env.VITE_TELEMETRY_PRODUCT_PID || "MahaVistaar";

  const config = {
    pdata: {
      id: productId,
      ver: productVersion,
      pid: productPid
    },
    channel: telemetryChannel + "-" + getHostUrl(),
    sid: sessionId,
    uid: userDetailsObj['preferred_username'] || "DEFAULT-USER",
    did: userDetailsObj['email'] || "DEFAULT-USER",
    authtoken: "",
    host: telemetryHost
  }

  const startEdata = {};
  const options = {};
  const token = AuthTokenGenerate.generate(key, secret);
  config.authtoken = token;
  Telemetry.start(config, "content_id", "contetn_ver", startEdata, options);
};

export const logQuestionEvent = (questionId: string, sessionId: string, questionText: string) => {
  const telemetryChannel = import.meta.env.VITE_TELEMETRY_CHANNEL || "MahaVistaar";
  const target = {
    "id": "default",
    "ver": "v0.1",
    "type": "Question",
    "questionsDetails": {
      "questionText": questionText,
      "sessionId": sessionId
    }
  };

  const questionData = {
    qid: questionId,
    type: "CHOOSE",
    target: target,
    sid: sessionId,
    channel: telemetryChannel + "-" + getHostUrl()
  };

  Telemetry.response(questionData);
};

export const logResponseEvent = (questionId: string, sessionId: string, questionText: string, responseText: string) => {
  const telemetryChannel = import.meta.env.VITE_TELEMETRY_CHANNEL || "MahaVistaar";
  const target = {
    "id": "default",
    "ver": "v0.1",
    "type": "QuestionResponse",
    "questionsDetails": {
      "questionText": questionText,
      "answerText": responseText,
      "sessionId": sessionId
    }
  };

  const responseData = {
    qid: questionId,
    type: "CHOOSE",
    target: target,
    sid: sessionId,
    channel: telemetryChannel + "-" + getHostUrl()
  };

  Telemetry.response(responseData);
};

export const logErrorEvent = (questionId: string, sessionId: string, error: string) => {
  const telemetryChannel = import.meta.env.VITE_TELEMETRY_CHANNEL || "MahaVistaar";
  const target = {
    "id": "default",
    "ver": "v0.1",
    "type": "Error",
    "questionsDetails": {
      "errorText": error,
      "sessionId": sessionId
    }
  };

  const errorData = {
    qid: questionId,
    type: "CHOOSE",
    target: target,
    sid: sessionId,
    channel: telemetryChannel + "-" + getHostUrl()
  };

  Telemetry.response(errorData);
};

export const logFeedbackEvent = (questionId: string, sessionId: string, feedbackText: string, feedbackType: string, questionText: string, responseText: string) => {
  const telemetryChannel = import.meta.env.VITE_TELEMETRY_CHANNEL || "MahaVistaar";
  const target = {
    "id": "default",
    "ver": "v0.1",
    "type": "Feedback",
    "feedbackDetails": {
      "feedbackText": feedbackText,
      "sessionId": sessionId,
      "questionText": questionText,
      "answerText": responseText,
      "feedbackType": feedbackType
    }
  };

  const feedbackData = {
    qid: questionId,
    type: "CHOOSE",
    target: target,
    sid: sessionId,
    channel: telemetryChannel + "-" + getHostUrl()
  };

  Telemetry.response(feedbackData);
};

export const endTelemetry = () => {
  Telemetry.end({});
};







