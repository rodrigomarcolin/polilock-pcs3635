import {
    IonContent,
    IonHeader,
    IonPage,
    IonTitle,
    IonToolbar,
    IonButton,
    useIonModal,
} from "@ionic/react";

import UnlockedModal from "./UnlockedModal";
import BlockedModal from "./BlockedModal";
import { useMqtt } from "../../contexts/MqttContext";
import { useEffect } from "react";
import { getMqttTopic } from "../../config";

import LockBtnCard from "./LockBtnCard";
import VerifyPasswordForm from "./VerifyPasswordForm";

const UnlockPage: React.FC = () => {
    const { isLocked, isBlocked } = useMqtt();

    const [presentUnlockedModal, dismissUnlockedMOdal] = useIonModal(
        UnlockedModal,
        {
            onDismiss: () => dismissUnlockedMOdal(),
        }
    );

    const [presentBlockedModal, dismissBlockedModal] = useIonModal(BlockedModal, {
        onDismiss: () => dismissBlockedModal(),
    });

    useEffect(() => {
        if (!isBlocked) {
            presentBlockedModal();
        }
    }, [isBlocked]);

    useEffect(() => {
        if (!isLocked) {
            presentUnlockedModal();
        }
    }, [isLocked]);

    return (
        <IonPage>
            <IonHeader>
                <IonToolbar>
                    <IonTitle>Destrancar Armário</IonTitle>
                </IonToolbar>
            </IonHeader>
            <IonContent className={"ion-padding ion-margin"} fullscreen>
                <IonHeader collapse="condense">
                    <IonToolbar>
                        <IonTitle size="large">Destrancar Armário</IonTitle>
                    </IonToolbar>
                </IonHeader>

                <VerifyPasswordForm />
                <LockBtnCard />
            </IonContent>
        </IonPage>
    );
};

export default UnlockPage;
