import {
  IonContent,
  IonHeader,
  IonIcon,
  IonPage,
  IonTitle,
  IonToolbar,
} from "@ionic/react";

import MqttDebugCard from "./MqttDebugCard";
import DebugWarningToolbar from "./DebugWarningToolbar";

const DebugPage: React.FC = () => {
  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>DEBUG</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent className={"ion-padding ion-margin"} fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">DEBUG</IonTitle>
          </IonToolbar>
        </IonHeader>

        <DebugWarningToolbar />
        <MqttDebugCard />
      </IonContent>
    </IonPage>
  );
};

export default DebugPage;
